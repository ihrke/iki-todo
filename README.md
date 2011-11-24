# todo for ikiwiki #

This [ikiwiki]-plugin provides a 
  
    [[!todo ]]

and a

    [[!todolist]]

directive for [ikiwiki]. 

[ikiwiki]: http://ikiwiki.info/

**Incomplete! still need to do**

* pagelist
* includedone


**Features:**

* todo/done items
* different listings
* handles the case when todo-items are inlined in other pages


## Arguments ##

* todo-directive:
    + type is one of 
        - todo - a new todo item, requires text=
		- done - a completed todo item, requires text=
* todolist-directive
    + type is one of
	    - list- a bullet-list of all todos linked to their page(s)
		- pagelist - a tree-list of all todos by page
	+ includedone - when present, list also done items 
* when a text= argument is given, type=todo is assumed unless
  otherwise specified
  
## Notes ##

* todos are wrapped in &gt;div id='todo_open'&lt; containers
* done items are wrapped in &gt;div id='todo_done'&lt; containers
* possible css:

        #todo_open {
        	 color: red;
        }
        
        #todo_open:before {
        	 content: "TODO: ";
        }
        
        #todo_done {
        	 color: green;
        }
        
        #todo_done:before {
        	 content: "Done: ";
        }

## Examples ##

Add a todo

    [[!todo text="my todo"]]

and a completed todo

    [[!todo text='my todo' type=done]]

and print the list as linked bullets

	[[!todolist]]

or tree-like according to page

	[[!todolist type=pagelist]]
