#!/usr/bin/perl
#
# Everytime a [[!todolist]] directive is found, add_depends() adds
#  dependencies such that this page is build again, whenever those
#  pages are modified.  I just pass * to add_depends for now, so every
#  page that has a [[!todolist]] directive is rebuilt whenever any
#  page changes.
#
# Policy:
#  * every [[!todo]] directive registers in the $wikistate{'todo'} variable
#  * the [[!todolist]] preprocess fct displays todos based on the wikistate
#  * [[!todolist]] calls add_depends( page, '*') 
#       + this ensures, that whenever an existing todo is modified or a new todo
#         is added, the todolist is updated
#
#  * items in wikistate are arraned as follows:
#       + wikistate{'todo'}{'open'}{'todo text'}=[page1, page2, ...]
#       + wikistate{'todo'}{'done'}{'todo text'}=[page1, page2, ...]
#                                                  

package IkiWiki::Plugin::todo;
use warnings;
use strict;
use IkiWiki 3.00;

use Data::Dumper;

#use Text::Format;

sub import {
    hook(type => "getsetup", id => "todo", call => \&getsetup);
    hook(type => "preprocess", id => "todo", call => \&todo_preprocess);
    hook(type => "preprocess", id => "todolist", call => \&todolist_preprocess);
}

sub getsetup () {
    return 
		  plugin => {
            description => "todo plugin",
            safe => 1,
            rebuild => 1,
            section => "misc",
	 },
}

sub uniq {
    return keys %{{ map { $_ => 1 } @_ }};
}

sub todo_preprocess {
    my %params=@_;
	 my $page=$params{destpage}; # this is the current page
	 my $type="todo";
	 my $text="";
	 my $output="";

	 if( exists $params{type} ){
		  $type=$params{type};
	 }

	 if( $type eq 'todo' ){
		  $text=$params{text} or die "need text for a todo item";
		  unless( exists $wikistate{'todo'}{'open'}{$text} ){
				$wikistate{'todo'}{'open'}{$text}=[];
		  }
		  my %h=map { $_ => 1 } @{ $wikistate{todo}{open}{$text} };
		  unless( exists $h{$page} ){
				push( @{ $wikistate{todo}{open}{$text} }, $page );
		  }

		  $output.="<div id='todo_open'>".$text."</div>";
	 } elsif ( $type eq 'done' ){
		  $text=$params{text} or die "need text for a todo item";
		  unless( exists $wikistate{'todo'}{'done'}{$text} ){
				$wikistate{'todo'}{'done'}{$text}=[];
		  }
		  my %h=map { $_ => 1 } @{ $wikistate{todo}{done}{$text} };
		  unless( exists $h{$page} ){
				push( @{ $wikistate{todo}{done}{$text} }, $page );
		  }
		  
		  %h=map { $_ => 1 } keys %{ $wikistate{todo}{open} };
		  if( exists $h{$text} ){
				delete $wikistate{todo}{open}{$text};
		  }
		  $output.="<div id='todo_done'>".$text."</div>";
	 } 

	 return $output;
}

sub todolist_preprocess {
    my %params=@_;
	 my $page=$params{destpage}; # this is the current page
	 my $type="list";
	 my $text="";
	 my $output="";

	 if( exists $params{type} ){
		  $type=$params{type};
	 }

	 if( $type eq 'list' ){
		  foreach my $txt (keys %{ $wikistate{'todo'}{'open'} } ) {
				foreach my $p (@{ $wikistate{'todo'}{'open'}{$txt} }) {
					 $output .= "* ".$txt." ([[".$p."]])\n";
				}
		  }
	 }

	 debug( Dumper($wikistate{'todo'}));
	 add_depends($params{page}, '*');

	 return $output;
}


1
