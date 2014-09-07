//= require jquery
//= require jquery_ujs
//= require access_control/bootstrap.min
//= require access_control/chosen.jquery.min
//= require access_control/plugins/metisMenu/metisMenu.min
//= require access_control/plugins/dataTables/jquery.dataTables
//= require access_control/plugins/dataTables/dataTables.bootstrap
//= require access_control/sb-admin-2

$.ajaxSetup({
  beforeSend: function(x, h, r){
    x.setRequestHeader('X-CSRF-Token', '<%= form_authenticity_token %>');
  },
  error: function(x,h,r){
    if( x.status == 422 ){
      console.log(["Sorry, but you don't have required permission to access this url - ", this.url].join(''));
    }
  }
});

/*
 <!-- /#wrapper -->
    <!-- jQuery Version 1.11.0 -->
    <script src="/assets/access_control/jquery-1.11.0.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="/assets/access_control/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="/assets/access_control/plugins/metisMenu/metisMenu.min.js"></script>
    
    <!-- DataTables JavaScript -->
    <script src="/assets/access_control/plugins/dataTables/jquery.dataTables.js"></script>
    <script src="/assets/access_control/plugins/dataTables/dataTables.bootstrap.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="/assets/access_control/sb-admin-2.js"></script>
    <script type="text/javascript">
      $.ajaxSetup({
        beforeSend: function(x, h, r){
          x.setRequestHeader('X-CSRF-Token', '<%= form_authenticity_token %>');
        }
      });
    </script>
*/
