Flow of the spa booking process

1. User chooses a service
2. User chooses a therapist
3. User chooses a date and time slot
4. User is redirected to the payment page
5. User is redirected to the confirmation page
6. System send email to the user with the booking details with QR checkin code

7. System send notification to the therapist with the booking details
8. User can cancel the booking
9. User can reschedule the booking
10. User can view the booking details
11. User can view the booking history
12. User can view the booking status
13. User can view the booking details
14. User can view the booking history
15. User can view the booking status

State of the appointments

1. Created
2. Confirmed
3. Cancelled
4. Rescheduled
5. Completed
6. No-show

Use BookingController for booking process

With therapist selection, create a servlet to get therapist for each service user book in booking summary

### 3. Browser Storage (Client-Side)

Use localStorage/sessionStorage for immediate state recovery:

- Store booking steps completion status
- Store selected values for each step
- Validate against server session on page load

### 4. Implementation Strategy
