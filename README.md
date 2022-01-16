# Vyanjan App

## Directory structure

- `features`
  - It contains separate directories according to features in the app
  - `FoodMaker`
    - All the features related to Food maker role should be in this directory for better distinguition of role wise features
  - `FoodSeeker`
    - All the features related to Food seeker role should be in this directory
  - `CommonScreens`
    - This directory contains all the pages which are going to be sed by both of the roles
  - `InitialScreens`
    - This directory contains screens/pages for Splashscreen, App tour screens etc.

 - `fixtures`
   - This directory is for testing purposes.
   - It contains dummy data for testing and development purpose
   - This must be removed in the production app
   - 
  - `resources`
    - This directory contains various resources which are going to be used in the app like colors, fonts etc.
    - 
 - `routes`
    - This directory contains various routes which are going to be used in the app for navigation purpose.
    - 
  - `widgets`
    - This directory conatins various custom widgets which can be used in various features throughout the app.

## External libraries used
 - pin_code_fields
 - intl_phone_number_input