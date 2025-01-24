# lanars_test_task
My option was Option 1, but I accidentally did some tasks from Option 2 😅
What was done:

Complexity сlarification:
	Option 1 - your tasks marked with “x” ( [ ] is optional )
	Option 2 - your tasks marked with “x” and “xx”  ( [ ] is optional )

Design:
https://www.figma.com/file/Vl5Al9Nix2wzWIxBXozhYW/Test  ✅ ❌

Non-functional requirements:
- [x] Platforms: [Android, iOS]    ✅ (iOS not tested)
- [x] Compatibility:
		Acceptance criteria:
- [x] Android: starting from API level 28 ✅
- [x] iOS: latest version and 2 previous versions  ✅

- [x] Every data-bound operation should have loading, error, empty, data state on UI ✅
- [x] Use material behavior (e.g. ripple effect, elevation etc.) ✅
- [x] Follow the design theme, text styles and dimensions (tried but not good ✅ ❌)
- [] Dark/light mode support (optional) ❌
TIP: There is an exported color scheme at the bottom of document

Functional Requirements:
- [x] As a user I want to log in the app so that I can access the app functionality ✅
		Design label: Log in
API documentation:
- [x] request url: https://randomuser.me/api/ (use a response data to fill the Drawer) ✅
- [x] request body (FYI: Request body will be ignored in the response. Use it just to show the flow): ✅
{
“email”: String,
“password”: String
}
		Acceptance criteria:
- [x] There is validation for inputs (there are validation rules below) ✅
- [x] Validation triggers: (login-button pressed; input lost focus) ✅
- [x] Reset error state on value changed ✅
- [x] After successful login, user is redirected to the main page ✅
- [x] Disable inputs and button on request ✅
- [xx] User stays logged in until logout action ❌

- [x] As a user I can view my profile data so that I can view the information I have ✅
Design label: Main (drawer)
Acceptance criteria (use data from login response):
- [x] There is a user avatar ✅
- [x] There is a user full name ✅
- [x] There is a user email ✅
 
- [xx] As a user I want to log out the app so that I can stop using its functionality or log in using other credentials ✅
		Design label: Main (drawer; alert)
Acceptance criteria:
- [xx] There should be a confirmation dialog to log out. ✅
- [xx] Users should have an option to cancel the log out process. ✅
- [xx] After successful log out, users are redirected to the login page. ✅

- [x] As a user I can view feed of photos so that I can find desired kind ✅
	Design label: Main (grouped)
API documentation:
 	- [x] https://www.pexels.com/api/documentation/#photos-curated 	 ✅
use https://api.pexels.com/v1/curated?per_page=50
for UI use image resource (url or any src), photographer name and alt (it could be empty)
Acceptance criteria:
- [xx] There is a paging implemented
- [x] There is a local sorting implemented by name (ASC) ✅
- [x] The list is grouped by name ✅
TIP: UI should not freeze during sorting/grouping with huge dataset 
	- [x] As a user I can refresh the feed so that I can get actual data ✅
Acceptance criteria:
- [x] There is an option to refresh the feed ✅

- [xx] As a user I can search by name so that I can find desired kind ✅
		Design label: Main (search input; empty)
		Acceptance criteria:
		- [xx] The search starts from the 3d symbol ✅
		- [xx] The search throttle time is 1000 ms ❌
		- [xx] There is an option to clear search input ✅
TIP: Implement search logic locally. 


Technical Requirements:
Architecture for Flutter test task:
- [x] https://pub.dev/packages/bloc ✅
- [x] https://pub.dev/packages/dio ✅
- [x] https://pub.dev/packages/retrofit ❌
- [x] https://pub.dev/packages/auto_route ✅
- [] https://pub.dev/packages/realm
- [] https://pub.dev/packages/json_serializable
- [] https://pub.dev/packages/get_it
- [] https://pub.dev/packages/injectable
- [] https://pub.dev/packages/equatable

Architecture for Android test task:
- [x] Android Jetpack (Compose UI, MVVM, Preferences DataStore)
- [] Hilt (optional)
- [] https://github.com/LanarsInc/compose-easy-route (optional)

Git:
- [x] Git-flow is mandatory ✅
- [x] Write declarative commit message ✅ 
- [x] Each commit should contain changes that are described at commit message (at the beginning I forgot to write a commit message, but not in the end) ✅ 

Validation rules:
email:
- [x] Should be between 6 and 30 characters ✅
- [x] RegEx: ^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]{1,10}@(?:(?!.*--)[a-zA-Z0-9-]{1,10}(?<!-))(?:\.(?:[a-zA-Z0-9-]{2,10}))+$ ✅
password:
- [x] Should be between 6 and 10 characters ✅
- [x] Uppercase letter is required ✅
- [x] Lowercase letter is required ✅
- [x] Digit is required ✅


Outcome
- [x] Link to the github repository ✅
- [x] Short README on what is done, how to build and run a project, what has to be done, how would you ✅
do this (optional)

For start progect just download repository, and paste your API key to https://api.pexels.com in pexel_api_service.dart on 8 row - final String apiKey = pexelsKey;
Then you can run it on your device or emulator.

![image](https://github.com/user-attachments/assets/a4c78171-952e-418f-8a27-4ea36f458eef)

![image](https://github.com/user-attachments/assets/8b2000ca-3004-47d6-a0b8-d5618931bef1)

![image](https://github.com/user-attachments/assets/5466008f-5346-46d4-b274-7fa6acefb985)

![image](https://github.com/user-attachments/assets/4c6ac5bd-d952-40bd-8ff8-aa7d88ea58fa)

![image](https://github.com/user-attachments/assets/ff27c8cf-eb88-43b5-982e-87f97042239e)

![image](https://github.com/user-attachments/assets/bfd12f43-30ee-4eb7-b51f-8bcc2c0713be)

![image](https://github.com/user-attachments/assets/fa83d595-1311-4313-9892-a82c8ad2db44)

Start searching only when > symbols
![image](https://github.com/user-attachments/assets/86bd658d-df8c-4e90-8569-852812f67155)

![image](https://github.com/user-attachments/assets/db91b8d8-157e-436e-8be4-eba0288f3eca)

![image](https://github.com/user-attachments/assets/cb955bbe-8f9d-4536-b8cc-f2386f3dd0a5)








