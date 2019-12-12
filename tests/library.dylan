Module: dylan-user

define library regular-expressions-test-suite
  use common-dylan;
  use io,
    import: { streams };
  use system,
    import: { file-system,
              locators,
              operating-system };
  use strings;
  use testworks;
  use regular-expressions,
    import: { regex-implementation };
end library;

define module regular-expressions-test-suite
  use common-dylan;
  use simple-format;
  use regex-implementation;
  use file-system;
  use locators,
    import: { <directory-locator>,
              <file-locator>,
              locator-name,
              subdirectory-locator };
  use operating-system,
    import: { environment-variable };
  use testworks;
  use streams;
  use strings,
    import: { strip-left };
end module;


