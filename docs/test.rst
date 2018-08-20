===============
Test Page
===============

Hello
===============
.. sidebar:: Line numbers and highlights

	 a header:
	   highlights the lines.
	 linenos:
	   shows the line numbers as well.
	 caption:
	   shown at the top of the code block.
	 name:
	   may be referenced with `:ref:` later.

::

	sysuse auto, clear
	scatter mpg weight

.. raw:: html

	<div style="clear: right;"></div>

A new title
===========
some text, and then a warning and note

.. important:: This is a warning directive.
   some warning text is important here, and don't forget

   - to watch out for this
   - and that.

.. note:: This is an important note that I put here
	in order to note something.

Code
====
.. toggle-header::
	:header: Example 1 **Show/Hide Code**

	Content for header

.. content-tabs::

    .. tab-container:: tab1
        :title: Tab title one

        Content for tab one
