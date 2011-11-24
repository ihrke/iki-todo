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

package IkiWiki::Plugin::todo;
use warnings;
use strict;
use IkiWiki 3.00;

use Data::Dumper;

#use Text::Format;

sub import {
	 hook(type => "scan", id => "todo", call => \&scan_for_todos);
	 hook(type => "needsbuild", id => "todo", call => \&todo_needsbuild);

    hook(type => "getsetup", id => "todo", call => \&getsetup);
    hook(type => "preprocess", id => "todo", call => \&todo_preprocess);
    hook(type => "preprocess", id => "todolist", call => \&todolist_preprocess);
}

sub todo_needsbuild {
	 # careful with sequence:
	 #  * first the todo-pages must be built and the hash be constructed
	 #  * then the todo-list can be compiled
	 my $listref=shift;
	 debug(  Dumper( @{ $listref } ) );
	 foreach my $f (@{ $listref }){
		  my $c = readfile($config{'srcdir'}."/".$f);
	 }
}


sub scan_for_todos {
	 my %params=@_;
	 my $p=$params{'page'} ;
	 my $c=$params{'content'} ;
	 while( $c =~ /\[\[\!todo (.*?)\]\]/g ){
		  debug(">>TODO:".$p."-'".$1."'\n");
	 }
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
		  unless( exists $wikistate{'todo'}{$page} ){
				$wikistate{'todo'}{$page}=[];
		  }
		  my %h=map { $_ => 1 } @{ $wikistate{'todo'}{$page} };
		  unless( exists $h{$text} ){
				push( @{ $wikistate{'todo'}{$page} }, $text );
		  }
		  #@{ $wikistate{'todo'}{$page} }=uniq( @{ $wikistate{'todo'}{$page} } );

		  $output.="<div id='todo_open'>".$text."</div>";
	 } elsif ( $type eq 'done' ){
		  $text=$params{text} or die "need text for a todo item";
		  
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
		  foreach my $p (keys %{ $wikistate{'todo'} } ) {
				foreach my $txt (@{ $wikistate{'todo'}{$p} }) {
					 $output .= "* [[".$txt."|".$p."]]\n";
				}
		  }
	 }

	 debug( Dumper($wikistate{'todo'}));
	 debug(">> todo: adding everything as dependency");
	 add_depends($params{page}, '*');

	 return $output;
}


1
