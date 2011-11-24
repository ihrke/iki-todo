#!/usr/bin/perl
package IkiWiki::Plugin::todo;
use warnings;
use strict;
use IkiWiki 3.00;

use Data::Dumper;

#use Text::Format;

my %todos; # holds page=>[ todo1, todo2, ... ]

sub import {
	 hook(type => "scan", id => "todo", call => \&scan_for_todos);
    hook(type => "getsetup", id => "todo", call => \&getsetup);
    hook(type => "preprocess", id => "todo", call => \&todo_preprocess);
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
		  unless( exists $todos{$page} ){
				$todos{$page}=[];
		  }
		  push( @{ $todos{$page} }, $text );
		  $output.="<div id='todo_open'>".$text."</div>";
	 } elsif ( $type eq 'done' ){
		  $text=$params{text} or die "need text for a todo item";
		  $output.="<div id='todo_done'>".$text."</div>";
	 } elsif( $type eq 'list' ){
		  foreach my $key ( keys %todos ) {
				foreach my $el (@{ $todos{$key} }) {
					 $output .= "* [[".$el."|".$key."]]\n";
				}
		  }
	 }


	 return $output;
}


1
