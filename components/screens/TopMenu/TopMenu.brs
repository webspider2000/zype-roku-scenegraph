' ********** Copyright 2016 Zype.  All Rights Reserved. **********
 'setting top interfaces
Sub Init()
    m.top.observeField("focusedChild", "OnFocusedChildChange")

    m.content_helpers = ContentHelpers()

    m.Scene = m.top.getScene()
    m.MenuButtons = m.top.findNode("MenuButtons")
    m.hiddentitle = m.top.findNode("hiddentitle")
    m.gMenu = m.top.findNode("gMenu")

    m.hideMenuAnimation = m.top.findNode("hideMenuAnimation")
    m.hideMenuAnimation.observeField("state", "onHideMenuAnimationState")
    m.showMenuAnimation = m.top.findNode("showMenuAnimation")
    m.showMenuAnimation.observeField("state", "onShowMenuAnimationState")
    m.shade = m.top.findNode("Shade")

    InitSidebarButtons()

    ' Set theme

    ' m.shade.color = m.global.theme.background_color
    m.shade.blendcolor = m.global.theme.background_color
    ' m.shade.color = m.global.theme.background_color
    m.userAction = false
    '
    ' m.MenuButtons.color = m.global.theme.primary_text_color
    ' m.MenuButtons.focusedColor = m.global.theme.secondary_text_color
    m.MenuButtons.focusBitmapUri = m.global.theme.button_focus_uri
    '
    m.top.menuShowAnimationCompleted = false
    m.top.menuShowAnimationCompleted = false
    m.top.observeField("focusedChild", "OnFocusedChildChange")
End Sub
sub onHideMenuAnimationState()
    if m.hideMenuAnimation.state = "stopped" Then
        m.top.menuHideAnimationCompleted = true
    end if
end sub

sub onShowMenuAnimationState()
    print " onShowMenuAnimationState "
    if m.showMenuAnimation.state = "stopped" Then
        m.top.menuShowAnimationCompleted = true
    end if
end sub

function TriggerHideMenu()
  print "Topmenu triggerhidemenu"
    m.hideMenuAnimation.control = "start"
end function

function TriggerShowMenu()
  print "Topmenu TriggerShowMenu"
    m.showMenuAnimation.control = "start"
end function

sub OnFocusedChildChange()
    ' print "TopMenu : OnFocusedChildChange IsInFocusChain : " m.top.IsInFocusChain()
    ' print "TopMenu : OnFocusedChildChange hasFocus : " m.MenuButtons.hasFocus()
    if m.top.isInFocusChain() and not m.MenuButtons.hasFocus() then
        print " m.Scene.LastSelectedMenu => :: " m.Scene.LastSelectedMenu
        m.MenuButtons.setFocus(true)
    end if
end sub

Function InitSidebarButtons()
    result = []
    print "[TopMenu] InitSidebarButtons"
    print "m.top.isRefreshMenu: "; m.top.isRefreshMenu

    columnWidths = "["

    hometextWidth = 0
    searchTextWidth = 0
    infoTextWidth = 0
    acccountTextWidth = 0
    favTextWidth = 0
    mylibraryTextWidth = 0
    testTextWidth = 0
    menuColumnWidth = CreateObject("roArray", 7, true)

    totalMenuItem = 0
    ' Home'
    initialselected = ""
    intialFocusIndex = 0
    if (m.Scene.LastSelectedMenu = m.global.labels.menu_home_button OR m.Scene.LastSelectedMenu = "")
        initialselected = "initialselected"
        intialFocusIndex = 0
    end if

    menuButtons = [
        { title: m.global.labels.menu_home_button, ShortDescriptionLine1: m.global.labels.menu_home_button, ShortDescriptionLine2: initialselected, role: "transition", target: "GridScreen"}
    ]

    m.hiddentitle.text = m.global.labels.menu_home_button
    hometextWidth = m.hiddentitle.BoundingRect().width
    totalMenuItem++
    menuColumnWidth.Push(hometextWidth)

    if m.global.enable_epg = true then menuButtons.push( { title: m.global.labels.menu_my_tv_button, ShortDescriptionLine1: m.global.labels.menu_my_tv_button, ShortDescriptionLine2: initialselected, role: "transition", target: "EPGScreen" } )

    if(m.global.device_linking = true )

        initialselected = ""
        if (m.Scene.LastSelectedMenu = m.global.labels.menu_account_button)
            initialselected = "initialselected"
            intialFocusIndex++
        end if
        menuButtons.push( { title: m.global.labels.menu_account_button, ShortDescriptionLine1: m.global.labels.menu_account_button, ShortDescriptionLine2: initialselected, role: "transition", target: "AccountScreen" } )
        m.hiddentitle.text = m.global.labels.menu_account_button
        acccountTextWidth = m.hiddentitle.BoundingRect().width
        totalMenuItem++
        menuColumnWidth.Push(acccountTextWidth)
    else
        if (m.global.marketplace_connect_svod or (m.global.auth<>invalid and m.global.auth.isLoggedIn <> invalid and m.global.auth.isLoggedIn <> false))

            initialselected = ""
            if (m.Scene.LastSelectedMenu = m.global.labels.menu_account_button)
                initialselected = "initialselected"
                intialFocusIndex++
            end if
            menuButtons.push( { title: m.global.labels.menu_account_button, ShortDescriptionLine1: m.global.labels.menu_account_button, ShortDescriptionLine2: initialselected, role: "transition", target: "AccountScreen" } )
            m.hiddentitle.text = m.global.labels.menu_account_button
            acccountTextWidth = m.hiddentitle.BoundingRect().width
            totalMenuItem++
            menuColumnWidth.Push(acccountTextWidth)
        end if
    end if


    if m.global.universal_tvod
        initialselected = ""
        if (m.Scene.LastSelectedMenu = m.global.labels.menu_my_library_button)
            initialselected = "initialselected"
            intialFocusIndex++
        end if
        menuButtons.push({ title: m.global.labels.menu_my_library_button, ShortDescriptionLine1: m.global.labels.menu_my_library_button, ShortDescriptionLine2: initialselected, role: "transition", target: "MyLibrary" })
        m.hiddentitle.text = m.global.labels.menu_my_library_button
        mylibraryTextWidth = m.hiddentitle.BoundingRect().width
        totalMenuItem++
        menuColumnWidth.Push(mylibraryTextWidth)
    end if

    ' Search'
    initialselected = ""
    if (m.Scene.LastSelectedMenu = m.global.labels.menu_search_button)
        initialselected = "initialselected"
        intialFocusIndex++
    end if

    menuButtons.push({ title: m.global.labels.menu_search_button, ShortDescriptionLine1: m.global.labels.menu_search_button, ShortDescriptionLine2: initialselected, role: "transition", target: "Search"})
    m.hiddentitle.text = m.global.labels.menu_search_button
    searchTextWidth = m.hiddentitle.BoundingRect().width
    totalMenuItem++
    menuColumnWidth.Push(searchTextWidth)

    ' Info Screen'
    initialselected = ""
    if (m.Scene.LastSelectedMenu = m.global.labels.menu_info_button)
        initialselected = "initialselected"
        intialFocusIndex++
    end if

    menuButtons.push({ title: m.global.labels.menu_info_button,  ShortDescriptionLine1: m.global.labels.menu_info_button, ShortDescriptionLine2: initialselected, role: "transition", target: "InfoScreen" })
    m.hiddentitle.text = m.global.labels.menu_info_button
    infoTextWidth = m.hiddentitle.BoundingRect().width
    totalMenuItem++
    menuColumnWidth.Push(infoTextWidth)

    ' Favorite'
    initialselected = ""
    if (m.Scene.LastSelectedMenu = m.global.labels.menu_favorites_button)
        initialselected = "initialselected"
        intialFocusIndex++
    end if

    menuButtons.push({ title: m.global.labels.menu_favorites_button, ShortDescriptionLine1: m.global.labels.menu_favorites_button, ShortDescriptionLine2: initialselected, role: "transition", target: "Favorites" })
    m.hiddentitle.text = m.global.labels.menu_favorites_button
    favTextWidth = m.hiddentitle.BoundingRect().width
    totalMenuItem++
    menuColumnWidth.Push(favTextWidth)

    ' Test menu'

    if m.global.test_info_screen
      initialselected = ""
      if (m.Scene.LastSelectedMenu = m.global.labels.menu_test_info_button)
          initialselected = "initialselected"
          intialFocusIndex++
      end if
      menuButtons.push( {title: m.global.labels.menu_test_info_button, ShortDescriptionLine1: m.global.labels.menu_test_info_button, ShortDescriptionLine2: initialselected, role: "transition", target: "TestInfoScreen" } )
      m.hiddentitle.text = m.global.labels.menu_test_info_button
      testTextWidth = m.hiddentitle.BoundingRect().width
      totalMenuItem++
      menuColumnWidth.Push(testTextWidth)
    end if

    content = m.content_helpers.oneDimList2ContentNode(menuButtons, "TopMenuItemData")
    m.MenuButtons.columnWidths = menuColumnWidth
    m.MenuButtons.itemSpacing = [60,0]

    totalTextW = 0
    maxWidth = 0

    For each item in menuColumnWidth
     totalTextW += item
      if item > maxWidth then maxWidth = item
    End For

    MenuWidth = totalTextW + (60*totalMenuItem)
    xPos = (1280 - MenuWidth)/2

    m.shade.width = MenuWidth - 10
    m.shade.translation = [xPos + 6,27.5]
    m.MenuButtons.itemSize = [0, maxWidth]
    m.MenuButtons.numColumns = totalMenuItem
    m.MenuButtons.content = m.content_helpers.oneDimList2ContentNode(menuButtons, "TopMenuItemData")
    m.MenuButtons.translation = [xPos + 6,0]
    ' m.showMenuAnimation.control = "start"
    m.MenuButtons.jumpToItem = intialFocusIndex
End Function

' on Menu Button press handler
Sub onItemFocused(event as dynamic)
    ? "[Menu] Button focused"
    ' index = m.top.itemSelected
    selectedOption = m.MenuButtons.itemFocused
    if (m.userAction = false AND selectedOption <> 0)
        m.userAction = true
        m.Scene.callFunc("StopHideMenuTimer")
    end if
    print "selectedOption ==========================================================::: " selectedOption
    ' childNode = m.MenuButtons.content.getChild(m.MenuButtons.itemFocused)
    ' selectedOptionTitle = childNode.TITLE
    ' print "Menu : selectedOption : " selectedOption
    ' print "Menu : selectedOptionTitle : " selectedOptionTitle
    '
    ' SelectOption(selectedOptionTitle)
    ' m.top.selectedPageNumber = selectedOption
    '
    ' m.top.itemSelectedRole = childNode.role
    ' m.top.itemSelectedTarget = childNode.target
end sub


' on Menu Button press handler
Sub onItemSelected()
    ? "[TopMenu] Button selected"
    index = m.top.itemSelected
    selectedOption = m.MenuButtons.itemFocused
    childNode = m.MenuButtons.content.getChild(m.MenuButtons.itemFocused)
    selectedOptionTitle = childNode.TITLE
    print "TopMenu : selectedOption : " selectedOption
    print "TopMenu : selectedOptionTitle : " selectedOptionTitle

    ' SelectOption(selectedOptionTitle)
    ' m.top.selectedPageNumber = selectedOption

    m.top.itemSelectedRole = childNode.role
    m.top.itemSelectedTarget = childNode.target
end sub

sub SelectOption(selectedOptionTitle as String)
    UpdateselectedOptionData(selectedOptionTitle)
end sub

sub UpdateselectedOptionData(selectedOptionTitle as String)
    for index = 0 to m.MenuButtons.content.getChildCount() - 1
        child = m.MenuButtons.content.getChild(index)
        ' print "TopMenu : Item title " child.title
        if child.title = selectedOptionTitle
            child.ShortDescriptionLine2 = "selected"
            m.Scene.LastSelectedMenu = selectedOptionTitle
        else
            child.ShortDescriptionLine2 = "unselected"
        end if
    end for
end sub

sub SelectMenuItem(selectedOptionTitle as String)
    ' print "TopMenu : SelectMenuItem " selectedOptionTitle
    ' print "TopMenu : SelectMenuItem m.MenuButtons " m.MenuButtons
    for index = 0 to m.MenuButtons.content.getChildCount() - 1
        child = m.MenuButtons.content.getChild(index)
        ' print "Menu : Item title " child.title
        if child.title = selectedOptionTitle
            ' print "Menu : Animate to"
            m.MenuButtons.jumpToItem = index
            exit for
        end if
    end for
    SelectOption(selectedOptionTitle)
    m.top.selectedPageNumber = index
 end sub

 ' Main Remote keypress event loop
Function OnKeyEvent(key, press) as Boolean
    ? ">>> TopMenu >> OnkeyEvent : " key " "press
    result = false
    if press then
        if key = "down" then
            ' m.hideMenuAnimation.control = "start"
            m.Scene.callFunc("TriggerHideMenu")
            result = true
        else if key = "OK" then
            result = true
        end if
    end if
    return result
end Function
