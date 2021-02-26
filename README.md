 ###### MoonCascade-Employee Test App #######

# Mooncascade-Job-Assignment
This was a recent job assignment that i did. It is an iOs app with a table view and detail view which loads data from an endpoints with custom Json Parsing for nested objects and displays it. Another feature of the app is to check the phones CNContacts for a match and shows CNContactViewController for native contact display and editing. 
                   

## Installation ##
-------------------------
--base target iOS 14.3
--permissions : user contacts
--use simulator or physcial device and build-run project




## Pattern  ##
----------------------


**MVVM**
--I chose this pattern over the more primitive MVC because of two reasons, the data could be sorted according to our requirements away form the View controller code. Whose sole resposibillity should be either configuring View(incase for XIB) or serving data to View.

**MVVM** is very similar to **MVC** but builds over it in todays appslication structure as mor eand more concurrent data manipulation can take place away from View controller, not giving you a bulky VC (which becomes a nightmare to test individual model operations).

--for NetworkHandler(shared instance **singleton**)

--**ENUM Result Types<T,Error>** introduced rather recently in **Swift Standard Library** is great for passing completion callback without multiple ***nil*** check logic 

-- **Parsing:CustomCoding** Keys to make sure further nested data and manipulation in future, having a decoder init helped for complex JSON

--***ArrangeEmployees : [KEY]: [KEY:[EMPLOYEE]]*** this lives in the core of the data to be displayed in my application. I Dont think it is the most optimised but i decided on this for two reason
    1.pattern to do reduce complexity of filter in **SearchViewController** which i could never complete so got rid of the optional requirement all together. ***(Further covered in optimization section)***
    2. dictionary grouping is covenient with dictionary(grouping by:) init
    
--**DispatchGroups:** for fetching multiple employees APIs this is very extendable if more APIs are added.



## Optimizations for next version  ##
---------------------------------------------------------

-- Due to timeContraints and much basic UI needs for the project i went for **Storyboard**, but id rather go with Programatically instantiating my View controllers as it gives me call the dependency like viewModels in the **init()** of the View controller.

-- **Optimized background** process for contact syncing with ***Contacts*** API by apple. this will go on after the initial table view is loaded and then by contact information of employees whose data exist in contacts app data would be added later and the ***contactCard** button can be enabled by  ***tableView.beginbatchupdates()*** .
Using this only selective table cells would be updated, so better user experience.

-- the refresh data can also be optimized by ***tableView.beginbatchupdates()***  instead of ***tableView.reloadData().*** Came across a resource for making selctive additions in DataSource after API calls
### https://medium.com/@stasost/ios-aimate-tableview-updates-dc3df5b3fe07 
This is tricky but i'm more than willing to implement in the future. From what i understood This can be done by **Model data struct have sections conform to equatable** as well to go **top to botton** tree traversing (positions of employee) key to their respective Array of employees(Arranged Employees). The change in data structure was keeping this in mind easing iterable collection for this applications use-case.

--The ***contactsViewController*** can be improved upon once i figure what is causing the navigationController of the BaseViewcontroller fail to assign it a place in the stack and hence cant **self.navigationController.present()**. Right now it uses another navigationcontroller instance and becomes its rootViewController to present itself. 
This seems to be occuring after iOS 13( source: Stackoverflow) according to others who have tried to implement.


                            ##### Happy Coding #####
