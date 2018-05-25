===========================================
Using Atom for text editing and git commits
===========================================

You've been using Stata's do-file editor to edit code. Of course the code is simply a text file, which means that you can use any text editor instead of Stata's text editor. In particular Atom is a nice text editor that integrates both Stata and git.

There is an icon for Atom on your desktop, and it's also available under Applications -> Development -> Atom

Writing and executing do-files in Atom
===========================================
Try creating and saving a do-file called :file:`test.do`::

	sysuse auto, clear
	summarize mpg weight, d
	scatter mpg weight

You can use Atom to send this code to Stata. To do this, open up Stata, side-by-side with Atom. In the Atom window containing your do-file, press :kbd:`Ctrl-Shift-D` to send the whole do-file to Stata (the do-file needs to be saved first).
