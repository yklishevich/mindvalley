# MindvalleyTrial

Trial ios project for Mindvalley company.

## My notices to the code

I ask to bear with me that I did't shape code better. Actually there are many places where readability and clearness of the code can be improved. I just dedicated a lot of time to caching into database.

I implemented support for decoding limited number of media items when downloading new episodes or channels. But current solution is not elegant and has it's own drawbacks. It's better to pass max number of items via `JsonDecoder.userInfo`. I dind't use this functionality anyway, but parsing only needed amount of data may make sense as it can a little bit accelerate downloading, and reduce amount of stored in DB data.

Quite a lot can be improved concerning error handling in code. For example to show user some message when there is no space left on disk and data cannot be cached for offline use. Errors are logged into local file. For logging error it would be better to user Crashlytics' support for logs.

When calculating layout in some places "magical constans" were used. In normal code named constants should be used and code should make it clear how this or that layout value was obtained. I didn't do this job accurately everywhere. In some places just added "TODO" and also added asserts for checking that value of some constants are in sync with values set in xib file.

In your design height of separator is 1pt, but in code I used value 1px. I think that designer just could not reflect that 1px (=0.5pt on retina with @2x) in design.

App lacks for comments, not much, but lacks. Just saved a bit time for showcasing working code.

For code quality would be nice to use Swiftgen (https://github.com/SwiftGen/SwiftGen) to avoid using string lirerals for restoring view controllers from storyboard and other string-based resources.

DAO pattern should provide interface to data layer hiding any implementation details of chosen persistent storage. But with coredata this is simingly impossible. I also have used Repository pattern and I think some code in that classes can be factored out.

I have implemented only one test just to show that I can. Didn't spend time for writing tests but this don'e mean that I consider them as waste of time. In my opinion if first place business requiremenst should be covered by tests, then, if time permits, maybe add UI tests.



## What parts of the test did you find challenging and why?

Most challenging was to calculate properly position of channel icon. Channel title may take up more than 1 line and according to design icon should be alligned nearer to the center of channel title than to the center of "episodes count" label. Just wanted this icon to be perfectly placed and recalled formulae for finding mass center.

## What feature would you like to add in the future to improve the project?

1. I think filtering would be nice addition.

2. Ability to update content (pull-to-refresh or something). Even better would be add some effecient sync mechanism. Effective in sence of traffic ammount.

3. When rotating screen being displayed cell can be changed. It would be nice to do some additional calculation and show to user the same item. 

4. Restore state of the app after relaunch of the app.

5. Somehow should be handled the case when error occurs during the very first downloading of data. Currently absent data is simply now shown.

6. When downloaded data differs from currently represented data it's better to animate changes in shown data. Curretly some attemps have been made in this direction (using diffable datasource for category buttons for example and animated reloading of the whole section of channels), but animating changes in list channels whould be better then curren animated reload of the whole section IMHO.

7. Add support for other languages. I marked the start in this direction.

8. There is bug in rendering text by apple's labels. For example text "The Cure For Loneliness" is wrapped into 2 lines "The Cure" and "For Loneliness" when there is enought space to put the word "For" in the filst line. 

9. I would add to each channel in new episode and to each episode (series) unique id in json. But just in case for future needs and it's more convenient identify piece of data by its id than by some set of attributes.

10. Maybe there is sence to organize lazy loading of data from DB than to hold all needed data in memory. This especially can become critical in the future with increasing amount of channels. This would decrease memory footage.



