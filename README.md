# todo for ikiwiki #

This [ikiwiki]-plugin provides a 
  
    [[!todo ]]
	 
directive for [ikiwiki]. 

[ikiwiki]: http://ikiwiki.info/

Features:

* todo/done items
* listings

## Requirements ##

## Arguments ##

* type is one of 
    + todo - a new todo item, requires text=
	+ done - a completed todo item, requires text=
	+ list - a bullet-list of all todos linked to their pages
	+ pagelist - a tree-list of all todos by page
* when a text= argument is given, type=todo is assumed unless
  otherwise specified
  

## Examples ##

Add a todo

    [[!todo text="my todo"]]

and a completed todo

    [[!todo text='my todo' type=done]]

and print the list as linked bullets

	[[!todo type=list]]

or tree-like according to page

	[[!todo type=pagelist]]
