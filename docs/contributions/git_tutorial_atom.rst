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

Accessing git through Atom
===========================================
The left-hand panel of Atom is your "Project" directory. If the directory is also a git repository, then you can access git and Github through Atom.

Try opening up your :file:`testrepo` repository. The bottom right corner of Atom allows you to fetch commits from, pull commits from, and push commits to your remote repository -- in this case, Github.

Try making a change to a file in your repository. Once you save the change, Atom will show "Unstaged changes" to this file in the right-hand panel. Use Atom to right-click the unstaged file to stage the change, add a commit message, and make a commit. After the commit, try pushing the change to Github.

Note that Atom also lets you switch and create branches. One thing Atom doesn't let you do is merge changes from one branch to another in your local repository -- for that you need the Github Desktop software (or command line or other software).
