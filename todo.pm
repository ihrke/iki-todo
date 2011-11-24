#!/usr/bin/perl
package IkiWiki::Plugin::todo;
use warnings;
use strict;
use IkiWiki 3.00;

use Data::Dumper;

#use Text::Format;

my %todos; # holds page=>[ todo1, todo2, ... ]

sub import {
    hook(type => "getsetup", id => "todo", call => \&getsetup);
    hook(type => "preprocess", id => "todo", call => \&todo_preprocess);
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
	 my $output_format="todo";

	 if( exists $params{type} ){
		  $output_format=$params{type};
	 }

	 unless( exists @todos{$page} ){
		  @todos{$page}=();
	 }
	 push( @todos{$page}, $text );

	 $output="<div id='todo'>".$text."</div>";

	 return $output;
}


1
