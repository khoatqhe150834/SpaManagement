-- This script adds an 'average_rating' column to the 'therapists' table and sets up
-- triggers to automatically keep it synchronized with data from the 'service_reviews' table.

-- Step 1: Add the average_rating column to the therapists table
-- This column will store the calculated average rating.
ALTER TABLE `therapists`
ADD COLUMN `average_rating` DECIMAL(3,2) NOT NULL DEFAULT 0.00 COMMENT 'Computed average rating from service_reviews, updated by triggers.';

-- -----------------------------------------------------------------------------

-- Step 2: Create a reusable function to calculate a therapist's average rating.
-- This simplifies the logic in the triggers and prevents code duplication.
DELIMITER $$

CREATE FUNCTION `calculate_therapist_avg_rating`(therapist_id INT)
RETURNS DECIMAL(3,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE avg_rating DECIMAL(3,2);

    -- Calculate the average rating from service_reviews by joining through appointments
    SELECT IFNULL(AVG(sr.rating), 0.00) INTO avg_rating
    FROM `service_reviews` sr
    JOIN `appointments` a ON sr.appointment_id = a.appointment_id
    WHERE a.therapist_user_id = therapist_id;

    RETURN avg_rating;
END$$

DELIMITER ;

-- -----------------------------------------------------------------------------

-- Step 3: Create triggers for the `service_reviews` table.
-- These triggers will fire when reviews are created, updated, or deleted.

-- Trigger for when a new review is inserted
DELIMITER $$

CREATE TRIGGER `trg_after_service_reviews_insert`
AFTER INSERT ON `service_reviews`
FOR EACH ROW
BEGIN
    DECLARE th_id INT;
    
    -- Find the therapist associated with the appointment
    SELECT `therapist_user_id` INTO th_id
    FROM `appointments`
    WHERE `appointment_id` = NEW.appointment_id;

    -- If a therapist is assigned, update their rating
    IF th_id IS NOT NULL THEN
        UPDATE `therapists`
        SET `average_rating` = calculate_therapist_avg_rating(th_id)
        WHERE `user_id` = th_id;
    END IF;
END$$

DELIMITER ;


-- Trigger for when a review is updated
DELIMITER $$

CREATE TRIGGER `trg_after_service_reviews_update`
AFTER UPDATE ON `service_reviews`
FOR EACH ROW
BEGIN
    DECLARE old_th_id INT;
    DECLARE new_th_id INT;

    -- This handles cases where the rating value changes.
    -- It also handles the unlikely case that the review is reassigned to a new appointment.
    IF OLD.rating <> NEW.rating OR OLD.appointment_id <> NEW.appointment_id THEN
        
        -- Get therapist from the old appointment
        SELECT `therapist_user_id` INTO old_th_id FROM `appointments` WHERE `appointment_id` = OLD.appointment_id;
        
        -- Get therapist from the new appointment
        SELECT `therapist_user_id` INTO new_th_id FROM `appointments` WHERE `appointment_id` = NEW.appointment_id;

        -- Update the new therapist's rating
        IF new_th_id IS NOT NULL THEN
            UPDATE `therapists` SET `average_rating` = calculate_therapist_avg_rating(new_th_id) WHERE `user_id` = new_th_id;
        END IF;

        -- If the appointment changed, update the old therapist's rating as well
        IF old_th_id IS NOT NULL AND old_th_id <> new_th_id THEN
            UPDATE `therapists` SET `average_rating` = calculate_therapist_avg_rating(old_th_id) WHERE `user_id` = old_th_id;
        END IF;
    END IF;
END$$

DELIMITER ;


-- Trigger for when a review is deleted
DELIMITER $$

CREATE TRIGGER `trg_after_service_reviews_delete`
AFTER DELETE ON `service_reviews`
FOR EACH ROW
BEGIN
    DECLARE th_id INT;

    -- Find the therapist associated with the deleted review's appointment
    SELECT `therapist_user_id` INTO th_id
    FROM `appointments`
    WHERE `appointment_id` = OLD.appointment_id;
    
    -- If a therapist was assigned, update their rating
    IF th_id IS NOT NULL THEN
        UPDATE `therapists`
        SET `average_rating` = calculate_therapist_avg_rating(th_id)
        WHERE `user_id` = th_id;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------------------------------

-- Step 4: Create a trigger for the `appointments` table.
-- This ensures that if a therapist is reassigned to a different appointment AFTER
-- a review has been made, the ratings for both the old and new therapists are updated.
DELIMITER $$

CREATE TRIGGER `trg_after_appointments_update`
AFTER UPDATE ON `appointments`
FOR EACH ROW
BEGIN
    -- Check if the therapist assignment has actually changed, and if a review exists for this appointment
    IF OLD.therapist_user_id <> NEW.therapist_user_id AND (SELECT COUNT(*) FROM `service_reviews` WHERE `appointment_id` = OLD.appointment_id) > 0 THEN
        
        -- Update rating for the old therapist
        IF OLD.therapist_user_id IS NOT NULL THEN
            UPDATE `therapists`
            SET `average_rating` = calculate_therapist_avg_rating(OLD.therapist_user_id)
            WHERE `user_id` = OLD.therapist_user_id;
        END IF;

        -- Update rating for the new therapist
        IF NEW.therapist_user_id IS NOT NULL THEN
            UPDATE `therapists`
            SET `average_rating` = calculate_therapist_avg_rating(NEW.therapist_user_id)
            WHERE `user_id` = NEW.therapist_user_id;
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------------------------------

-- Step 5: Run a one-time update to populate the new column for all existing therapists.
-- It's important to run this after creating the column and before relying on the triggers.
-- This version includes a WHERE clause on the primary key to avoid MySQL's "safe update mode" error (Error 1175).

-- Step 1: Temporarily disable safe update mode for this session
SET SQL_SAFE_UPDATES = 0;

-- Step 2: Run the update command to populate the ratings for all therapists
UPDATE `therapists` t
SET t.`average_rating` = (
    SELECT IFNULL(AVG(sr.rating), 0)
    FROM `service_reviews` sr
    JOIN `appointments` a ON sr.appointment_id = a.appointment_id
    WHERE a.therapist_user_id = t.user_id
);

-- Step 3: Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;

-- End of script 