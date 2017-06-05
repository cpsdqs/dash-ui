fs = require 'fs'
path = require 'path'

module.exports =
  activate: (state) ->
    @setIconsEnabled atom.config.get 'dash-ui.iconsEnabled'

    atom.config.onDidChange 'dash-ui.themeColor', =>
      @setTheme atom.config.get 'dash-ui.themeColor'

    atom.config.onDidChange 'dash-ui.iconsEnabled', =>
      @setIconsEnabled atom.config.get 'dash-ui.iconsEnabled'

  setTheme: (color) ->
    color = color.toLowerCase()

    fileContent = """
    @accent: @#{color};
    """

    atomPackage = atom.packages.getLoadedPackage('dash-ui')

    filePath = path.join atomPackage.path,
      'styles',
      'theme.less'

    # this is really hacky
    fs.writeFile filePath, fileContent, (err) ->
      if err
        console.error '[dash-ui] Failed to save theme file', err
        atom.notifications.addError 'Failed to save theme color',
          dismissable: yes
      else
        atomPackage.deactivate()
        setImmediate ->
          atomPackage.activate()

          # While this does update colors that use the theme color directly,
          # for some reason any derivative color won't be updated, and I have
          # no idea how Atom manages style sheets.
          # So, for now, just create a notification telling the user to reload
          atom.notifications.addSuccess 'Reload required',
            detail: 'For the theme colors to properly update, ' +
              'Atom must be reloaded.'
            buttons: [
              text: 'Reload',
              className: 'btn',
              onDidClick: ->
                atom.commands.dispatch atom.views.getView(atom.workspace),
                  'window:reload'
            ]
            dismissable: yes
            icon: 'sync'


  setIconsEnabled: (value) ->
    if value
      atom.workspace.getElement().classList.add 'dash-icons-enabled'
    else
      atom.workspace.getElement().classList.remove 'dash-icons-enabled'
