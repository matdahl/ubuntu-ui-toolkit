/*
 * Copyright 2014 Canonical Ltd.
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

#ifndef UCLISTITEM_H
#define UCLISTITEM_H

#include <QtQuick/QQuickItem>
#include "ucstyleditembase.h"

class UCListItemContent;
class UCListItemPrivate;
class UCListItem : public UCStyledItemBase
{
    Q_OBJECT
    Q_PROPERTY(QQuickItem *contentItem READ contentItem CONSTANT)
    Q_PROPERTY(bool pressed READ pressed NOTIFY pressedChanged)
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(QColor highlightColor READ highlightColor WRITE setHighlightColor NOTIFY highlightColorChanged)
    Q_PROPERTY(QQmlListProperty<QObject> data READ data DESIGNABLE false)
    Q_PROPERTY(QQmlListProperty<QQuickItem> children READ children NOTIFY childrenChanged DESIGNABLE false)
    Q_CLASSINFO("DefaultProperty", "data")
public:
    explicit UCListItem(QQuickItem *parent = 0);
    ~UCListItem();

    QQuickItem *contentItem() const;
    bool pressed() const;
    QColor color() const;
    void setColor(const QColor &color);
    QColor highlightColor() const;
    void setHighlightColor(const QColor &color);

protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *data);
    void itemChange(ItemChange change, const ItemChangeData &data);
    void geometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry);
    void mousePressEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);

Q_SIGNALS:
    void pressedChanged();
    void colorChanged();
    void highlightColorChanged();
    void childrenChanged();

    void clicked();

public Q_SLOTS:

private:
    Q_DECLARE_PRIVATE(UCListItem)
    QQmlListProperty<QObject> data();
    QQmlListProperty<QQuickItem> children();
    Q_PRIVATE_SLOT(d_func(), void _q_updateColors())
    Q_PRIVATE_SLOT(d_func(), void _q_rebound())
    Q_PRIVATE_SLOT(d_func(), void _q_updateSize())
};

#endif // UCLISTITEM_H
