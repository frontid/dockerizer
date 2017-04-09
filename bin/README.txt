For best usability:

1- Install smartcd_config
2- Get to the root folder, and run:
echo "autostash PATH=$PWD/bin:\$PATH" | smartcd edit enter
This will add the bin directory to the path when someone enters on the project (and it will take it out when someone leaves!)

Enjoy!

*********************************************************************
IMPORTANT NOTE: If you just installed smartcd for the first time and
you haven't created a new shell, it may not be loaded yet.  Run

    source ~/.smartcd_config
*********************************************************************

To get started, create a few scripts.  Its easy!  Try this:

    echo 'echo hello there from $PWD' | smartcd edit enter
    echo 'echo goodbye from $PWD' | smartcd edit leave

Then simply leave the directory and come back.  For a more practical
example, how about tweaking your PATH?

    echo "autostash PATH=$PWD/bin:\$PATH" | smartcd edit enter

(side note: the quoting rules when editing in this fashion can be a bit
awkward, so feel free to run `smartcd edit` interactively too!

When you enter the directory, your $PATH will be updated and when you
leave it is restored to its previous value automagically.  How cool is
that?  For more detail on what is possible, read the documentation in
~/.smartcd/lib/core/smartcd or refer to the README at
https://github.com/cxreg/smartcd

