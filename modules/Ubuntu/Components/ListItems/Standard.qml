/*
 * Copyright 2012 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 0.1

/*!
    \qmltype Standard
    \inqmlmodule Ubuntu.Components.ListItems 0.1
    \ingroup ubuntu-listitems
    \brief The standard list item class. It shows a basic list item
        with a label (text), and optionally an icon, a progression arrow,
        and it can have an embedded Item (\l control) that can be used
        for including Buttons, Switches etc. inside the list item.

    \l {http://design.ubuntu.com/apps/building-blocks/list-items}{See also the Design Guidelines on List Items}.

    Examples:
    \qml
        import Ubuntu.Components 0.1
        import Ubuntu.Components.ListItems 0.1 as ListItem
        Column {
            ListItem.Standard {
                text: "Selectable standard list item"
                selected: false
                onClicked: selected = !selected
               }
            ListItem.Standard {
                text: "List item with icon"
                icon: Qt.resolvedUrl("icon.png")
            }
            ListItem.Standard {
                text: "With a progression arrow"
                progression: true
            }
            ListItem.Standard {
                text: "Control"
                control: Button {
                    text: "Click me"
                    width: units.gu(19)
                    onClicked: print("Clicked")
                }
                progression: true
            }
        }
    \endqml
    \b{This component is under heavy development.}
*/
Empty {
    id: listItem

    /*!
      \preliminary
      The location of the icon to show in the list item (optional), or an Item that is
      shown on the left side inside the list item. The icon will automatically be
      anchored to the left side of the list item, and if its height is undefined, to the top
      and bottom of the list item.
      \qmlproperty variant icon
    */
    property variant icon

    /*!
      \preliminary
      The location of the icon to show in the list item if iconSource failed to load (optional).
      \qmlproperty url fallbackIconSource
     */
    property alias fallbackIconSource: iconHelper.fallbackSource

    /*!
      \preliminary
      The text that is shown in the list item as a label.
      \qmlproperty string text
     */

    /*!
      \preliminary
      Show or hide the progression symbol.
     */
    property bool progression: false

    /*!
      \internal
      \deprecated
      Width of the icon to be displayed
    */
    property real __iconWidth

    /*!
      \internal
      \deprecated
      Height of the icon to be displayed
    */
    property real __iconHeight

    /*!
      \internal
      \deprecated
      The margins on the left side of the icon.
     */
    property real __leftIconMargin

    /*!
      \internal
      \deprecated
      The margins on the right side of the icon.
     */
    property real __rightIconMargin

    /*!
      \preliminary
      An optional control that is displayed inside the list item.
      The width of the control must be specified in order to determine
      the layout of the list item.

      The mouseArea of the control will be set to the full Standard list item if
      there is no \l progression, or only the part left of the split, if there is a
      \l progression.
      \qmlproperty AbstractButton control
    */
    property alias control: controlContainer.control

    /*!
      \preliminary
      Show or hide the frame around the icon
      \qmlproperty bool iconFrame
     */
    property alias iconFrame: iconHelper.hasFrame

    // If there is a control, the controlArea covers the listItem's mouseArea,
    // so in that case use the highlights below when pressed
    highlightWhenPressed: !listItem.control

    // Avoid emit clicked signals when clicking on the control area
    __acceptEvents: false

    /*!
      \internal
     */
    property bool __controlAreaPressed: false
    Rectangle {
        id: controlHighlight

        visible: listItem.swipingState === "" ? control && __controlAreaPressed : false
        anchors {
            top: parent.top
            right: progressionHelper.visible ? progressionHelper.left : parent.right
            bottom: parent.bottom
            left: parent.left
        }
        color: "#E6E6E6"
        opacity: 0.7
    }

    Rectangle {
        id: progressionHighlight

        visible: listItem.swipingState === "" ? listItem.progression && progressionHelper.showSplit && listItem.pressed && !__controlAreaPressed : false
        anchors {
            left: progressionHelper.left
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        color: "#E6E6E6"
        opacity: 0.7
    }

    IconVisual {
        id: iconHelper

        width: height
        anchors {
            left: parent.left
            leftMargin: listItem.__contentsMargins
            top: parent.top
            topMargin: units.gu(0.5)
            bottom: parent.bottom
            bottomMargin: anchors.topMargin
        }
    }

    /*!
      \internal
      The \l icon property is an Item. The value is false if \l icon is a string,
      or when no icon was set.
     */
    property bool __iconIsItem: false

    /*!
      \internal
     */
    onIconChanged: {
        if (typeof icon == "string") {
            // icon is the url of an image
            iconHelper.source = icon;
            __iconIsItem = false;
        } else {
            // icon is an Item.
            __iconIsItem = true;
            iconHelper.source = "";

            icon.parent = listItem;
            icon.anchors.left = listItem.left;
            icon.anchors.margins = Qt.binding(function() { return listItem.__contentsMargins });
            if (!icon.height) {
                icon.anchors.top = listItem.top;
                icon.anchors.bottom = listItem.bottom;
            }
        }
    }

    /*!
      \internal
      The \l foregroundGroundColor property stores the internal label color.
     */
    property alias __foregroundColor: label.color

    LabelVisual {
        id: label
        property bool anchorToIconHelper: !__iconIsItem && iconHelper.source != ""
        selected: listItem.selected
        anchors {
            verticalCenter: parent.verticalCenter
            left: anchorToIconHelper ? iconHelper.right : parent.left
            leftMargin: __iconIsItem ? icon.width + 2 * listItem.__contentsMargins : listItem.__contentsMargins
            right: control ? controlContainer.left : (progression ? progressionHelper.left : parent.right)
            rightMargin: listItem.__contentsMargins
        }
        text: listItem.text
    }

    Item {
        id: controlContainer
        property AbstractButton control
        // use the width of the control if there is (possibly elided) text,
        // or full width available if there is no text.
        width: control ? control.width : undefined
        anchors {
            right: listItem.progression ? progressionHelper.left : parent.right
            rightMargin: listItem.__contentsMargins
            top: parent.top
            bottom: parent.bottom
        }
        onControlChanged: {
            if (control) control.parent = controlContainer;
        }

        Connections {
            target: listItem.__mouseArea

            onClicked: {
                if (control && __mouseArea.mouseX < progressionHelper.x) {
                    if (control.enabled) control.clicked();
                } else {
                    listItem.clicked();
                }
            }

            onPressAndHold: {
                if (control && control.enabled && __mouseArea.mouseX < progressionHelper.x) {
                    control.pressAndHold();
                } else {
                    listItem.pressAndHold();
                }
            }
        }
    }

    /*!
      \internal
     */
    onPressedChanged: {
        if (listItem.pressed && control && control.enabled && (__mouseArea.mouseX < progressionHelper.x)) {
            listItem.__controlAreaPressed = true
        } else {
            listItem.__controlAreaPressed = false
        }
    }

    ProgressionVisual {
        id: progressionHelper
        visible: listItem.progression
        anchors {
            right: parent.right
            rightMargin: listItem.__contentsMargins
            top: parent.top
            bottom: parent.bottom
        }
        showSplit: control ? true : false
        splitMargin: listItem.__contentsMargins
    }
}
