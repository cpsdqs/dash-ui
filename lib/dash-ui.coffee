module.exports =
  activate: (state) ->
    @setIconsEnabled atom.config.get 'dash-ui.iconsEnabled'

    atom.config.onDidChange 'dash-ui.iconsEnabled', =>
      @setIconsEnabled atom.config.get 'dash-ui.iconsEnabled'

  setIconsEnabled: (value) ->
    if value
      atom.workspace.getElement().classList.add 'dash-icons-enabled'
    else
      atom.workspace.getElement().classList.remove 'dash-icons-enabled'
