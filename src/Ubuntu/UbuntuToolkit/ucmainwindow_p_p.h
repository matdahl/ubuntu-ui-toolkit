/*
 * Copyright 2016 Canonical Ltd.
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

#ifndef UCMAINWINDOW_P_H
#define UCMAINWINDOW_P_H

#include "ucpagetreenode_p_p.h"
#include "ucmainwindow_p.h"
#include <QQmlProperty>

UT_NAMESPACE_BEGIN

class UCMainWindow;
class UCPopupContext;

class UCMainWindowPrivate : public UCPageTreeNodePrivate
{
    Q_DECLARE_PUBLIC(UCMainWindow)

public:
    UCMainWindowPrivate();
    void init();

    QString m_applicationName;
    UCPopupContext* m_actionContext = nullptr;
    qint8 m_flags;

};

UT_NAMESPACE_END

#endif // UCMAINWINDOW_P_H
