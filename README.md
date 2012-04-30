Notre Dame Television for iPhone and iPod touch
===============================================

This is the Github repository storing the source code for the Notre Dame Television app for iPhone and iPod touch. This app is currently pending review for publication on the App Store.

App Description
---------------

This app is the final, end-user part of a chain of systems in use at [Notre Dame Television] (http://www.ndtv.net), the student-run television station at the University of Notre Dame. A series of job schedulers, batch programs, and web programs pull live schedule data from a Leightronix Nexus video broadcast device. This app displays this schedule data on iOS devices and allows users to schedule reminders to watch shows they would like. Reminders appear as local notifications, five minutes prior to the listed broadcast time.

Open Source Code
----------------

The source code for this app is released to the public under the terms of the MIT license. Refer to the `License` section below. However, please note that image files are not included in this release or in the open source license.

If you are rebuilding this app, you will need to replace these image files. A description of the image files required follows. Note that all image files should also have a Retina version at twice the resolution, with an `@2x` suffix appended to each image file name.

* Default.png - a modified screenshot of the primary app interface, with all data removed. This is displayed as the app loads, before the entire program as initialized
* icon_iphone.png - App icon
* icon_iphone_high.png - Retina version of app icon
* button_sel.png - selected day of the week (unless today is selected)
* button_today_sel.png - selected day of the week (if it is today)
* button_today.png - unselected current day button
* button.png - unselected day button for all days that are not today
* calendar.png - tab bar schedule icon
* cancel_remind.png - `Cancel Reminder` button as appears in show detail view, without text
* cell_background_iphone.png - background image for schedule items in schedule view
* delete.png - Delete button to remove reminders from Reminders tab, without text
* detail_generic_logo.png - generic show logo that appears in show detail view, shown while actual logo is downloaded
* divider.png - divider image used on various views
* generic_logo.png - generic show logo that appears in schedule view, shown while actual logo is downloaded
* hud_remind.png - reminder icon that appears as part of the confirmation HUD which appears when reminders are scheduled
* hud_undo.png - undo icon that appears as part of the confirmation HUD which appears when reminders are removed
* hud_X.png - error icon that appears as part of the confirmation HUD which appears when network errors occur
* info.png - icon that opens the about/legal information view
* masthead.png - image that appears at the top of the schedule and reminder views
* message_background.png - background of the Message Center
* note.png - general information icon used in the Message Center
* now.png - icon used to denote shows that are currently playing
* remind_cell_back.png - background of cells in the table in the reminder view
* remind_header.png - divider between the masthead and table in the reminder view
* remind.png - `Remind Me` button as appears in show detail view, without text
* reminder.png - tab bar reminder icon
* sched_table_back_iphone.png - background of schedule and reminder views
* updated.png - date last updated icon used in the Message Center

License
-------

This code is distributed under the terms and conditions of the MIT license.

Copyright (c) 2012 Kevin Li.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Additional Credits
------------------

This app uses the [MBProgressHUD] (https://github.com/jdg/MBProgressHUD) class, which is provided under the MIT license.

The license for MBProgressHUD follows:

```Copyright (c) 2009-2012 Matej Bukovinski

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.```