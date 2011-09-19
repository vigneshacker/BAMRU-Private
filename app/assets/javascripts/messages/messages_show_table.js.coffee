###
Used to sort photos (drag & drop)
Relies on jQuery UI
###

last_name_options =
  id:     'last_name'                             # the parser name
  is:     (s) -> false                            # disable standard parser
  type:   'text'                                  # either text or numeric
  format: (s) -> (new MemberName(s)).last_name()  # the sort key (last name)

sort_opts =
  headers:
    0: {sorter: 'last_name'}     # sort col 3 using last_name options
    6: {sorter: false }

$(document).ready ->
  $.tablesorter.addParser last_name_options
  $("#myTable").tablesorter(sort_opts)
