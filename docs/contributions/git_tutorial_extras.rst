========================================
Extra topics about git
========================================
You can do almost everything you need using Atom and Github Desktop, but if you use the command-line, git will do a lot more.

Undo a change in a file, prior to a commit
==========================================
If you want to undo everything in that file and change it back to the way it looked in the last commit, use

.. code-block:: none

  git checkout -- thefile

Undo a commit, prior to pushing to Github
=========================================
Use :code:`git reset <last good SHA>` or :code:`git reset --hard <last good SHA>`. Both commands undo all the commits back to the last good SHA. The former undoes the commits, but preserves the working directory and changes. The lastter undoes the commits and erases all the changes.

Undo a commit, after pushing to Github
======================================
After you've pushed changes, using :code:`git reset` to undo will cause problems when you want to push again. Instead, use :code:`git revert <SHA>`. This will create a new commit that reverses the changes you've made, so that you can get back to <SHA>.

Completely erase a local branch and replace it with what's on github
======================================================================
.. code-block:: none

  git checkout mybranch
  git fetch origin
  git reset --hard origin/mybranch

It is a good idea, just in case, to save your current branch's state before doing this. So use

.. code-block:: none

  git checkout mybranch
  git commit -a -m "Saving mybranch!"
  git branch savedmybranch

Other ways to undo stuff
========================
There are very good tips on `Github <https://blog.github.com/2015-06-08-how-to-undo-almost-anything-with-git/>`_.

Comparing branches or files
========================================
Want to see the difference between two branches?

.. code-block:: none

  git diff branchA branchB

Want to see the difference between two commits of the same file?

.. code-block:: none

  git diff SHA1> SHA2 -- thefile

Ignoring files
========================================
git is fantastic at tracking changes to text files, but it is usually the wrong tool to use to track changes to large binary files, like large datasets. You should tell git to ignore these files (it is also generally a good idea to tell git to ignore most of the output of your project after your code is run).

To do this, we use a :file:`.gitignore` file. This is simply a text file instructing git to ignore certain files. For example, to ignore all .dta and .xlsx files in your repository, create a file called :file:`.gitignore` in the root of your repository that contains the lines

.. code-block:: none

  *.dta
  *.xlsx

When you add the :file:`.gitignore` file you'll also need to stage and commit it so that it becomes part of your repository.
