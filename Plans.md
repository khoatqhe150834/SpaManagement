Objective:
Implement three homepage sections for services, each loading real data from the database. Refer to the database structure in schema_data_main.sql.

Sections to implement:
Recently Viewed Services Section

Display a list of services the user has recently viewed.

Save and retrieve recently viewed services from localStorage.

Replace any “Đặt ngay” buttons with a button labeled “Thêm vào giỏ” (Add to Cart), styled like the service cards in services.jsp.

Include a “Xem tất cả” (View All) button. When clicked, it should redirect the user to a page showing the full list of recently viewed services.

Promotional Services Section

Load services that are currently on promotion from the database.

Replace “Đặt ngay” buttons with “Thêm vào giỏ” buttons, matching the style used in services.jsp.

Include a “Xem tất cả” button redirecting to a full list of promotional services.

Most Purchased Services Section

Load the top-selling services from the database.

Replace “Đặt ngay” buttons with “Thêm vào giỏ” buttons as in services.jsp.

Include a “Xem tất cả” button redirecting to a page listing all most-purchased services.

Technical Requirements:
Use the service card template from services.jsp to ensure consistent design and styling.

Integrate the HTML markup for these sections into @index.jsp.

Move all JavaScript logic (e.g. API calls, localStorage handling, event listeners) into a separate JS file.

When users click “Thêm vào giỏ”, trigger the same behavior as in services.jsp.

Ensure “Xem tất cả” buttons redirect correctly to the respective listing pages.

Maintain responsiveness and clean layout.

Data Notes:
Query real service data from the database as per the schema in schema_data_main.sql.

Provide fallback handling if no data exists for a given section.

For Recently Viewed Services, use localStorage keys to store and retrieve service IDs or relevant info.
