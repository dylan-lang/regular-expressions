Module: regular-expressions-test-suite

define module-spec regular-expressions ()
  sealed instantiable class <regex> (<mark>);
  sealed instantiable class <regex-error> (<format-string-condition>, <error>);
  sealed instantiable class <invalid-regex> (<regex-error>);
  sealed generic-function regex-error-pattern
      (<invalid-regex>) => (<string>);
  sealed instantiable class <invalid-match-group> (<regex-error>);
  sealed instantiable class <match-group> (<object>);
  sealed instantiable class <regex-match> (<object>);

  // Compiling and accessing regex info
  sealed generic-function compile-regex
      (<string>, #"key", #"case-sensitive", #"dot-matches-all", #"verbose", #"multi-line")
      => (<regex>);
  sealed generic-function regex-pattern (<regex>) => (<string>);
  sealed generic-function regex-group-count
      (<regex>) => (<integer>);

  // Search and replace
  sealed generic-function regex-position
      (<regex>, <string>, #"key", #"start", #"end", #"case-sensitive")
      => (false-or(<integer>), #"rest");
  sealed generic-function regex-replace
      (<string>, <regex>, <string>, #"key", #"start", #"end", #"case-sensitive", #"count")
      => (<string>);
  sealed generic-function regex-search
      (<regex>, <string>, #"key", #"anchored", #"start", #"end")
      => (false-or(<regex-match>));
  sealed generic-function regex-search-strings
      (<regex>, <string>, #"key", #"anchored", #"start", #"end")
      => (false-or(<regex-match>));

  // Accessing match groups
  sealed generic-function groups-by-position
      (<regex-match>) => (<sequence>);
  sealed generic-function groups-by-name
      (<regex-match>) => (<sequence>);
  sealed generic-function match-group
      (<regex-match>) => (false-or(<string>), false-or(<integer>), false-or(<integer>));

  // Accessing individual group data
  sealed generic-function group-text
      (<match-group>) => (false-or(<string>));
  sealed generic-function group-end
      (<match-group>) => (false-or(<integer>));
  sealed generic-function group-start
      (<match-group>) => (false-or(<integer>));
end module-spec regular-expressions;


define library-spec regular-expressions-api ()
  module regular-expressions;
end;

