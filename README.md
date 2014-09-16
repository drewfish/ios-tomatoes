# Rotten Tomatoes Client

This is an iOS demo application for displaying movied/DVD info from http://rottentomatoes.com/

**Time spent:** 10 hours


## Completed User Stories

* [x] *required* -- view a list of movies
* [x] *required* -- poster images loading asynchronously
* [x] *required* -- view movie details by tapping on a cell
* [x] *required* -- loading state while waiting for movies API
* [x] *required* -- error message when there's a networking error
* [x] *required* -- pull to refresh the movie list
* [x] *required* -- used Cocoapods
* [x] *required* -- images use AFNetworking+UIImageView
* [x] *optional* -- customized highlight and selection effect of the cell
* [x] *optional* -- customized navigation bar
* [x] *optional* -- tab bar for Box Office and DVD
* [x] *optional* -- search bar for Box Office
 

## Notes

* created (mostly clean) delegation for TableView search versus non-search modes
* search calls the API after the "search" button is clicked. had to fight mighily to get this working
* occasional "double free" crashes when loading the Box Office list (non-search). no idea how to debug


## Walkthrough of All User Stories

![Video Walkthrough](hw.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).


