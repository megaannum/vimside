# vimside

Vim Scala IDE (VimSIde) built upon ENSIME

# Introduction

This is a pre-alpha release of Vimside, a Vim Scala IDE.
Only a small number of all of the ENSIME capabilities have
been implemented and it has only been tested against the
very small scala/java test source project bundled with it.

I have checked the source into github primarily so that
the source is somewhere other than on my local machines.
I expect to continue to update the sources on github
frequently, flushing out the features.


# Installation

## Download

One can download a zip snapshot or use a Vim plugin manager (such
as VAM).

## Dependency

Vimside depends upon Vimproc 
[GitHup]( https://github.com/Shougo/vimproc)
for a C-language binding to sockets
(and, thus to the Ensime server) and Vimshell 
[GitHup]( https://github.com/Shougo/vimshell)
for launching and managing communications with the Scala Repl.


## Directory layout

After unpacking the Vimside directory layout should look like:

    $HOME/.vim/
      autoload/
        vimside.vim
        vimside/
          " vimside code
      data/
        " data that persists between invocations of a plugin
        vimside/
            " examples, local test scala/java source tree
      doc/
        vimside.txt
      plugin/
        vimside.vim


## Intalling with vim-addon-manager (VAM)

For more information about vim-addon-manager, see [vim-addon-manager](https://github.com/MarcWeber/vim-addon-manager) and [Vim-addon-manager getting started](https://github.com/MarcWeber/vim-addon-manager/blob/master/doc/vim-addon-manager-getting-started.txt)

In your .vimrc, add self as shown below:

    fun SetupVAM()

      ...

      let g:vim_addon_manager = {}
      let g:vim_addon_manager.plugin_sources = {}

      ....

      let g:vim_addon_manager.plugin_sources['self'] = {'type': 'git', 'url': 'git://github.com/megaannum/self'}
      let g:vim_addon_manager.plugin_sources['forms'] = {'type': 'git', 'url': 'git://github.com/megaannum/forms'}
      let g:vim_addon_manager.plugin_sources['vimproc'] = {'type': 'git', 'url': 'git://github.com/Shougo/vimproc'}
      let g:vim_addon_manager.plugin_sources['vimshell'] = {'type': 'git', 'url': 'git://github.com/Shougo/vimshell'}
      let g:vim_addon_manager.plugin_sources['vimside'] = {'type': 'git', 'url': 'git://github.com/megaannum/vimside'}


      let plugins = [
        \ 'self',
        \ 'forms',
        \ 'vimproc',
        \ 'vimshell',
        \ 'vimside'
        \ ]

      call vam#ActivateAddons(plugins,{'auto_install' : 0})

      ...

    endf
    call SetupVAM()


Note that to use Vimside, the 'self' and 'forms' libraries above are
optional. With the 'forms' library, Vimside supports additional 
features such as a popmenu of commands and the type and package inspectors
(not yet implemented).

Now start Vim. You will be asked by vim-addon-manager 
if you would like to download and install the plugins.

## Installing with pathogen

I do not use pathogen. An example usage would be welcome.

# Usage

Look at the plugin/vimside.vim file for key mappings: how to
start the Ensime server and the currently supported commands.

RECOMMENDED for initial testing:
To run against test Scala/Java project, 
first in data/vimside copy example_options_user.vim to options_user.vim.

  > cd $HOME/.vim/data/vimside
  > /bin/cp example_options_user.vim options_user.vim

Then, in options_user.vim uncomment the following two lines:

   call a:option.Set("test-ensime-file-use", 1)
   call a:option.Set("ensime-config-file-name", "ensime_config.vim")

This tells Vimside to use the test project code and to use the
ensime_config.vim as the source for Ensime Configuration.

# Supported Platforms

Ought to work most everywhere

## Tutorial

None available yet.

## Acknowledgements and thanks

Daniel Spiewak has a JEdit binding to Ensime and a simply great video
explaining why a true editor with Ensime is better than an Eclipse 
Ide.

Jeanluc Chasseriau who wrote the python-based Envim Vim binding
to Ensime: https://github.com/jlc/envim.

