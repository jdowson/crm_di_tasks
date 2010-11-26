crm_di_tasks
============

** For the latest stable version use the v0.1.1 tag as the HEAD version will contain incomplete integration work to test the use of the Delta Indigo workflow manager with Fat Free CRM.**

Overview
--------

In versions > v0.1.1 this module modifies the behaviour of the [Fat Free CRM][2] **tasks** model to support attributes required for the proper functioning of the Delta Indigo workflow manager.

** OUTCOME RELATED **
* **task_text** - A longer description for the task
* **outcome_type_id** - A mandatory code (with default) to record the successful completion of the task from a **lookup** list. The list cascades from the task **category** to allow different outcomes per category.
* **outcome_sub_type_id** - An optional code to record further status information on the completion of the task from a **lookup** list. The list cascades from the task **outcome_type_id** to allow different outcomes per category.
* **outcome_text** - A field to allow the user to add notes relating to the outcome of the task.

**task_text** will be availible at all times on the task edit form, while the other fields will be visible in a separate section of the form. 

The outcome related fields will be visible on task lists (except outcome_text) once the task is marked is complete. 

The opportunity to complete the outcome fields will also be provided in a pop-up box when the task is completed.


** PARENT ASSET STATUS TRACKING **

The Delta Indigo workflow manager typically uses the completion by users of automatically generated tasks to progress the handling (such as status updates) of a parent asset. 

To provide a form of audit trail for these changes, the status of the parent asset (in this prototype it is assumed the asset will be an opportunity and 'status' will be used to indicate status) will be recorded on the task at both task creation and after each update.

* **asset_status_create** - Records the status (stage) of the parent asset with the task is initially created.
* **asset_status_update** - Records the status (stage) of the parent asset when the task is updated or completed.

These attributes will be visible, read-only on the task edit form.

In the future this behaviour will be delegated to an 'acts_as_workflowable' module.


Prerequisites
-------------

This module requires the [crm_di_core][4] plugin for [Fat Free CRM][2] to be installed and setup as per the repository instructions.


Installation
------------

From the root of your Fat Free CRM installation run:

> `./script/plugin install [source]`

Where [source] can be, according to your needs, one of:

> SSH:
>    `git@github.com:jdowson/crm_di_tasks.git`
>
> Git: 
>    `git://github.com/jdowson/crm_di_tasks.git`
>
> HTTP:
>    `https://jdowson@github.com/jdowson/crm_di_tasks.git`

The database migrations required for the plug can be installed with the following command:

> `rake db:migrate:plugin NAME=crm_di_tasks`

...that can be run from the Fat Free CRM installation root.


Sample Data
-----------

Sample *task.category*, *task.category.outcometype* and *task.category.outcometype.subtype* lookup fields may be created using the following *rake* command:

> `rake crm:di:tasks:setup`

These fields initially contain no lookup values. Sample values can be installed with the following *rake* command:

> `rake crm:di:tasks:demo`

These commands respond to the usual rake environment options, such as `RAILS_ENV=test`.


Tests
-----

See the *readme* for the [crm_di_core][4] repository for general comments on tests.


Copyright (c) 2010 [Delta Indigo Ltd.][1], released under the MIT license

[1]: http://www.deltindigo.com/                 "Delta Indigo"
[2]: http://www.fatfreecrm.com/                 "Fat Free CRM"
[3]: http://www.github.com/                     "github"
[4]: https://github.com/jdowson/crm_di_core     "crm_di_core"

