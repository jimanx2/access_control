[![Build Status](https://drone.io/github.com/jimanx2/access_control/status.png)](https://drone.io/github.com/jimanx2/access_control/latest)

access_control
==============

Just an In-House gem developed to provide an interactive way to control ACL in your Ruby on Rails application.

Requirements
=
The gem requires the following:

 1. Rails  4 (Will support 3.2 in future)
 2. SqLite, if you're starting new application. Other rails compatible DB driver will also be compatible with this gem
 3. Devise (for basic authentication)
 4. Jquery for Rails (jquery-rails)
 5. therubyracer gem

Getting Started - Configuration
=
**From Scratch**

 First let's create our new rails application (in terminal of course). Let's say the app name is -- acl_control
 
 > rails new acl_control --skip-bundle
 > cd acl_control

Next, lets edit our Gemfile (any plain text editor would do), it should look like this:

![enter image description here](https://lh5.googleusercontent.com/-eXqTeURKzHQ/VClMa1ZY-8I/AAAAAAAAAsY/mL8Rlz6E4HM/s0/Screen+Shot+2014-09-29+at+8.09.43+PM.png "Screen Shot 2014-09-29 at 8.09.43 PM.png")

Now uncomment "gem 'therubyracer', platforms: :ruby" line (because of requirement #5)

Next, add the following lines at the end of the file:

> gem "access_control", :github => "jimanx2/access_control"<br>
> gem "devise" # requirement #3

Having that done, save the file. Back to the terminal, run the following:

 > bundle install

on deployment server you might need to change the command to this:

> bundle install --deployment

You should have this:

![enter image description here](https://lh4.googleusercontent.com/-IKKqkCpPYmA/VClP6vssvSI/AAAAAAAAAss/z_Oj_Rao17I/s0/Screen+Shot+2014-09-29+at+8.25.47+PM.png "Screen Shot 2014-09-29 at 8.25.47 PM.png")

Now, we're going to generate a user model named 'User', and a role model named 'Role'. Run the following command:

> rails generate access_control User Role

It should end with something like this:

![enter image description here](https://lh4.googleusercontent.com/-KTvtokigKgs/VClQjolkt-I/AAAAAAAAAtA/Zb8Rsov_JuA/s0/Screen+Shot+2014-09-29+at+8.28.26+PM.png "Screen Shot 2014-09-29 at 8.28.26 PM.png")

The process creates a few database migration files in the "db/migrate" folder. Thus, we need to run the following:

*but before that, make sure you check your config/database.yml file and make changes on it according to your project's setup.*

>RAILS_ENV=(environment e.g production) rake db:migrate

If the command completes without any error(s), proceed to the following command:

> RAILS_ENV=(environment e.g production) rake db:seed

It creates one Role named "Administrator" and a User with email: "admin@yoursite.com", password: "password" assigned to the "Administrator" role.  Expect the command to run without any output.

To test the configuration, run `rails server` command. Then, head over to http://localhost:3000/acl-mgr using your browser. Sign in with email and password as stated above, and you should see the following page:

![enter image description here](https://lh4.googleusercontent.com/-pX75jPTyYMY/VClT-htgOgI/AAAAAAAAAtY/K1YbcObo5XM/s0/Screen+Shot+2014-09-29+at+8.43.04+PM.png "Screen Shot 2014-09-29 at 8.43.04 PM.png")

Usage
=

When you have successfully followed steps above, you can use the ACL functions in your application like this: 
(e.g in `application_controller.rb`)

> permitted? "&lt;route name&gt;", current_user

The use of *current_user* variable depends on your devise settings.

To make AccessControl limit URLs that your application's user can access, you must include the following line in appropriate location inside your `application_controller.rb` file:

> before_filter :authenticate_user!, :acl_verifyroute!

Now every actions of your controllers will be filtered by AccessControl depending on permissions you defined in the `/acl-mgr` page.

**What about actions that I want to expose to public users?**

Rails comes with the `skip_before_filter` method which lets you to bypass either or both `authenticate_user!` / `acl_verifyroute!` filter. Let's say you have a PostsController with action `show`, so your `posts_controller.rb` file should start with this:

> class PostsController < ApplicationController <br>
> skip_before_filter :authenticate_user!, :acl_verifyroute!, :only => [:show] <br>
> ...

read more about skip_before_filter at 
<a href="http://guides.rubyonrails.org/action_controller_overview.html#filters">http://guides.rubyonrails.org/action_controller_overview.html#filters</a> 

**Using AccessControl to filter page elements**

There are two integrated methods provided in the ActionView classes (which is available in your view files), namely: `menuitem_for` and `element_for`.

These method will return true if there is a permission defined in `/acl-mgr` page. Refer **Defining permission** section for more about this.

**menuitem_for - usage**

> <% menuitem_for posts_show_path do %> <br>
> &lt;a href="<%= @url %>"&gt;Show Posts&lt;/a&gt; <br>
> <% end %>

The above script will check for permission of `posts#show` action for `current_user`. If the permission is false, the link simply not written in the page.

**element_for - usage**

> <% element_for '@PostsView' do %> <br>
> &lt;div&gt;< p>All Posts< /p>&lt;/div&gt; <br>
> <% end %>

This method works similarly like `menuitem_for` method. But, it is for HTML elements, if the permission is false, the &lt;div&gt; will not be shown.

**I have link(s) that appear in more than one page. How should filter these links?**

AccessControl also come with `Module` feature. It allows you to group multiple routes and elements, and let you use it at different places.

**Defining AccessControl Module**

Head over to `/acl-mgr` page, look for the "Modules" submenu, you should be able to expand it to see the "Define module" link:

![enter image description here](https://lh3.googleusercontent.com/-8Kqas177xUU/VClcnVkc_oI/AAAAAAAAAt0/TrOQLtA0vOY/s0/Screen+Shot+2014-09-29+at+9.20.02+PM.png "Screen Shot 2014-09-29 at 9.20.02 PM.png")

Click on that link, you will see the following dialog:

![enter image description here](https://lh3.googleusercontent.com/-kmpMLRF9FJ0/VCldGshX43I/AAAAAAAAAuI/HzHjMzR0pnM/s0/Screen+Shot+2014-09-29+at+9.22.09+PM.png "Screen Shot 2014-09-29 at 9.22.09 PM.png")

fill in the "Module Name" field, can be other than shown value, but you must not include space in the name, use dash (-) instead. Then press submit. Click on "OK" or "yes" on the confirmation dialog. And you should see your module in the `Modules` submenu:

![enter image description here](https://lh6.googleusercontent.com/-8VcZFCm5sRY/VCldyRa7X2I/AAAAAAAAAuc/htzPsIMmMug/s0/Screen+Shot+2014-09-29+at+9.25.12+PM.png "Screen Shot 2014-09-29 at 9.25.12 PM.png")

**Adding routes/elements to modules**

Now click on your module link created in previous step, you should see the following screen:

![enter image description here](https://lh5.googleusercontent.com/-JrpDdZB1ox0/VCleJiSZonI/AAAAAAAAAuw/yJmrb87f8iI/s0/Screen+Shot+2014-09-29+at+9.26.42+PM.png "Screen Shot 2014-09-29 at 9.26.42 PM.png")

Click on "Insert Route" button, you will see a dialog with a select box and a text field:

![enter image description here](https://lh4.googleusercontent.com/-wnXwj0QMoNI/VCleeHaq4bI/AAAAAAAAAvE/Cv4TOXx5HkM/s0/Screen+Shot+2014-09-29+at+9.27.58+PM.png "Screen Shot 2014-09-29 at 9.27.58 PM.png")

Simply pick a route that matches your desired action. For example, `posts#show` (hint: you can type in the box as well). You also can add multiple selection if you want. It should let you insert route in the module faster.

You can optionally insert @ElementName in your module if you used **element_for** method. For example: @PostsView

![enter image description here](https://lh5.googleusercontent.com/--MgIb8md9fQ/VClfrzAEgjI/AAAAAAAAAvU/73QwM0H2jE0/s0/Screen+Shot+2014-09-29+at+9.33.15+PM.png "Screen Shot 2014-09-29 at 9.33.15 PM.png")

Click on submit to proceed. Then click on "OK" or "Yes". Now the table will have some new entry:

![enter image description here](https://lh6.googleusercontent.com/-sDazr98ukD8/VClgCvz-zcI/AAAAAAAAAvo/qtX4U8SfQl8/s0/Screen+Shot+2014-09-29+at+9.34.40+PM.png "Screen Shot 2014-09-29 at 9.34.40 PM.png")

**Defining Permission**

To actually limit your user from accessing certain pages, you have to define the permission. To do this, go to `/acl-mgr` and click on the "Pemissions" link. You will see the following:

![enter image description here](https://lh3.googleusercontent.com/-UVGs42i_saQ/VClhrHE5bqI/AAAAAAAAAv8/XXyeXoZraxA/s0/Screen+Shot+2014-09-29+at+9.41.39+PM.png "Screen Shot 2014-09-29 at 9.41.39 PM.png")

Click on "New Permission Button"

![enter image description here](https://lh6.googleusercontent.com/-fj9d8VT9Af4/VCliAkEupDI/AAAAAAAAAwQ/4wIrei98ZwI/s0/Screen+Shot+2014-09-29+at+9.43.06+PM.png "Screen Shot 2014-09-29 at 9.43.06 PM.png")

You will see a dialog box with "Pick Route", "Requester" and "Action?". To select your module, click on the select box, and/either scroll down until you find "!(your-modul-name)" e.g "!post-page" or type the route name, and then select it.

Then select Requester (can be a Role, or a User):

![enter image description here](https://lh3.googleusercontent.com/-QcR269LVDSk/VCljHYwMqSI/AAAAAAAAAww/f__nGceV50s/s0/Screen+Shot+2014-09-29+at+9.47.54+PM.png "Screen Shot 2014-09-29 at 9.47.54 PM.png")

When you see it, the "edit me in app/models/user.rb" is defined in `app/models/user.rb` file. Simply change that to your values for example: the `name` column of users table, or can be other column.

Select the action (either ALLOW, or DENY). Then click submit button. click on "OK" or "Yes". Then the permission table should appear like this:

![enter image description here](https://lh6.googleusercontent.com/-7aPRGvGrcgs/VClkEAgESlI/AAAAAAAAAxM/EdbfbJ--a5Q/s0/Screen+Shot+2014-09-29+at+9.51.50+PM.png "Screen Shot 2014-09-29 at 9.51.50 PM.png")

To change the permission value of it, you can slide/click on the green switch beside the Permission column of the table.

And that's it. You're done.

**Customizing Settings**

If you have models other than in the instruction, you will need to change appropriate values in `config/initializers/access_control.rb`.

AccessControl.configure do |config| <br>
  config.superadmin_role = "Administrator" # value of "name column in roles table"<br>
  config.userclass = :user # use User model, users table<br>
  config.roleclass = :role # use Role model, Role table<br>
  config.acl_exit_path = '/' # sets the location of "Back to User Dashboard" button in the manager page <br>
end 