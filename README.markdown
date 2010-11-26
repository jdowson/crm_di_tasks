crm_di_tasks
============

Overview
--------

For the moment this plugin simply acts as a test harness for the [crm_di_core][4] plugin for [Fat Free CRM][2], as well as demonstrating the changing of Fat Free behaviour through controller hooks, adding the following attributes to the *task* model:

* **task_text** - A longer description for the task
* **outcome_type_id** - A mandatory code (with default) to record the successful completion of the task from a **lookup** list. The list cascades from the task **category** to allow different outcomes per category.
* **outcome_sub_type_id** - An optional code to record further status information on the completion of the task from a **lookup** list. The list cascades from the task **outcome_type_id** to allow different outcomes per category.
* **outcome_text** - A field to allow the user to add notes relating to the outcome of the task.

**task_text** will be availible at all times on the task edit form, while the other fields will only be visible on a completed task. 

The outcome related fields will only be visible on task lists (except outcome_text) and the edit form once the task is marked is complete. 
The opportunity to complete the outcome fields will also be provided in a pop-up box when the task is completed.


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

