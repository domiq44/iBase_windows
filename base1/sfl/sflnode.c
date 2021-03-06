/*===========================================================================*
 *                                                                           *
 *  sflnode.c - Linked list functions, deprecated                            *
 *                                                                           *
 *  Copyright (c) 1991-2009 iMatix Corporation                               *
 *                                                                           *
 *  ------------------ GPL Licensed Source Code ------------------           *
 *  iMatix makes this software available under the GNU General               *
 *  Public License (GPL) license for open source projects.  For              *
 *  details of the GPL license please see www.gnu.org or read the            *
 *  file license.gpl provided in this package.                               *
 *                                                                           *
 *  This program is free software; you can redistribute it and/or            *
 *  modify it under the terms of the GNU General Public License as           *
 *  published by the Free Software Foundation; either version 2 of           *
 *  the License, or (at your option) any later version.                      *
 *                                                                           *
 *  This program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            *
 *  GNU General Public License for more details.                             *
 *                                                                           *
 *  You should have received a copy of the GNU General Public                *
 *  License along with this program in the file 'license.gpl'; if            *
 *  not, write to the Free Software Foundation, Inc., 59 Temple              *
 *  Place - Suite 330, Boston, MA 02111-1307, USA.                           *
 *                                                                           *
 *  You can also license this software under iMatix's General Terms          *
 *  of Business (GTB) for commercial projects.  If you have not              *
 *  explicitly licensed this software under the iMatix GTB you may           *
 *  only use it under the terms of the GNU General Public License.           *
 *                                                                           *
 *  For more information, send an email to info@imatix.com.                  *
 *  --------------------------------------------------------------           *
 *===========================================================================*/

#include "prelude.h"                    /*  Universal header file            */
#include "sfllist.h"                    /*  Linked-list functions            */
#include "sflmem.h"                     /*  Memory allocation functions      */
#include "sflnode.h"                    /*  Prototypes for functions         */

Bool
    node_unsafe = FALSE;                /*  When we're changing a list       */


/*  ---------------------------------------------------------------------[<]-
    Function: node_create

    Synopsis: Creates a new node with the specified size, and attaches it to
    the linked list after the specified node.  Initialises all fields in the
    node (except the main list pointers) to binary zeroes.  If the 'after'
    argument is null, initialises but does not attach the node.  Returns a
    pointer to the newly-created node, or NULL if there was not enough memory.

    Examples:
    typedef struct {
        void *prev, *next;
        long data;
    } BLOCK;

    NODE head;
    BLOCK *pointer;

    //  Initialise head of list
    node_reset (&head);

    //  Attach new block to start of list
    pointer = (BLOCK *) node_create (&head, sizeof (BLOCK));
    pointer-> data = 1;

    //  Attach new block to end of list
    pointer = (BLOCK *) node_create (head.prev, sizeof (BLOCK));
    pointer-> data = 1000;
    ---------------------------------------------------------------------[>]-*/

void *
node_create (
    void *after,
    size_t size)
{
    NODE
        *node;                          /*  Allocated node                   */

    ASSERT (size > 0);

    if ((node = mem_alloc (size)) != NULL)
      {
        memset (node, 0, size);
        node_reset (node);              /*  Initialise node pointers         */
        if (after)                      /*  Link into list if required       */
            node_relink_after (node, after);
      }
    return (node);
}


/*  ---------------------------------------------------------------------[<]-
    Function: node_destroy

    Synopsis: Unlinks the specified node from any list it may be in, and
    frees its memory.
    ---------------------------------------------------------------------[>]-*/

void
node_destroy (
    void *node)
{
    ASSERT (node);

    node_unlink (node);
    mem_free (node);
}


/*  ---------------------------------------------------------------------[<]-
    Function: node_relink_after

    Synopsis: Links a node into a doubly-linked list after a point in the
    list.  Generally a linked list is attached to a 'head': an empty list
    consists of just the head node.  To attach a node to the start of the
    list, link after the head.  To attach a node to the end of the list,
    link before the head using node_relink_before().  In this way you can
    build doubly-ended queues, fifo queue, lists, etc.  Returns the address
    of the node.
    ---------------------------------------------------------------------[>]-*/

void *
node_relink_after (
    void *node,
    void *after)
{
    return (node_relink (after, node, ((NODE *) after)-> next));
}


/*  ---------------------------------------------------------------------[<]-
    Function: node_relink_before

    Synopsis: Links a node into a doubly-linked list before a point in the
    list.  To link a node to the end of a doubly-linked list, link it before
    the list header node.
    ---------------------------------------------------------------------[>]-*/

void *
node_relink_before (
    void *node,
    void *before)
{
    return (node_relink (((NODE *) before)-> prev, node, before));
}


/*  ---------------------------------------------------------------------[<]-
    Function: node_unlink

    Synopsis: Unlinks the node from any list it may be in.  Returns node.
    ---------------------------------------------------------------------[>]-*/

void *
node_unlink (
    void *node)
{
    return (node_relink (((NODE *) node)-> prev, node,
                         ((NODE *) node)-> next));
}


/*  ---------------------------------------------------------------------[<]-
    Function: node_relink

    Synopsis: Links the node into a linked list.  This is a general-purpose
    function that can be used to attach and remove nodes anywhere in a list.
    Sets the global variable 'node_unsafe' while the list is being changed.
    Returns the address of node.
    ---------------------------------------------------------------------[>]-*/

void *
node_relink (
    void *left,
    void *node,
    void *right)
{
    NODE *swap;

    node_unsafe = TRUE;
    swap = ((NODE *) left)-> next;      /*  Exchange left pointers           */
           ((NODE *) left)-> next = ((NODE *) node)-> next;
                                    ((NODE *) node)-> next = swap;

    swap = ((NODE *) right)-> prev;     /*  Exchange right pointers          */
           ((NODE *) right)-> prev = ((NODE *) node)-> prev;
                                     ((NODE *) node)-> prev = swap;
    node_unsafe = FALSE;
    return (node);
}
