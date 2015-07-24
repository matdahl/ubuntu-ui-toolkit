/*
 * Copyright 2015 Canonical Ltd.
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
 *
 * Author: Loïc Molinari <loic.molinari@canonical.com>
 */

#include "ucubuntushapeicon.h"

const qreal aspectRatio = 16.0 / 15.0;
const qreal invAspectRatio = 1.0 / aspectRatio;

/*! \qmltype UbuntuShapeIcon
    \instantiates UCUbuntuShapeIcon
    \inqmlmodule Ubuntu.Components 1.3
    \ingroup ubuntu
    \brief Extended UbuntuShape mostly used for icons and vignettes.

    The UbuntuShapeIcon is an extended \l UbuntuShape with a fixed aspect ratio (16:15), a relative
    radius and a drop shadow aspect. Changing the width implies an update of height and radius, as
    well as changing the height implies an update of width and radius. The goal being to keep the
    same proportion between width, height and radius whatever the size.
*/
UCUbuntuShapeIcon::UCUbuntuShapeIcon(QQuickItem* parent)
    : UCUbuntuShape(parent)
{
    setAspect(UCUbuntuShape::DropShadow);
    setRelativeRadius(0.5);
    connect(this, SIGNAL(widthChanged()), this, SLOT(updateHeight()));
    connect(this, SIGNAL(heightChanged()), this, SLOT(updateWidth()));
}

void UCUbuntuShapeIcon::updateWidth()
{
    const qreal newWidth = height() * aspectRatio;
    if (qAbs(newWidth - width()) > 0.5) {
        setWidth(newWidth);
    }
}

void UCUbuntuShapeIcon::updateHeight()
{
    const qreal newHeight = width() * invAspectRatio;
    if (qAbs(newHeight - height()) > 0.5) {
        setHeight(newHeight);
    }
}
