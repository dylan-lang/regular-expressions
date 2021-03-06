Module: regular-expressions-test-suite

// Helper function, e.g., check-matches("a(b|c)", "abc", "ab", "b")
// Note that flags must come at the end of groups-and-flags.
define function check-matches
    (pattern, input-string, #rest groups-and-flags) => ()
  let string? = rcurry(instance?, <string>);
  let groups = groups-and-flags;
  let flags = #[];
  let flags-start = find-key(groups-and-flags, rcurry(instance?, <symbol>));
  if (flags-start)
    flags := copy-sequence(groups-and-flags, start: flags-start);
    groups := copy-sequence(groups-and-flags, end: flags-start);
  end;
  let regex = apply(compile-regex, pattern, flags);
  let match = regex-search(regex, input-string);
  if (empty?(groups))
    check-false(format-to-string("Regex '%s' matches '%s'", pattern, input-string),
                match);
  else
    for (group in groups, i from 0)
      check-equal(format-to-string("Regex '%s' group %d is '%s'", pattern, i, group),
                  group,
                  if (match)
                    match-group(match, i)
                  else
                    "{no such group}"
                  end);
    end;
  end;
end function check-matches;

define test split-test ()
  let big-string = "The rain in spain and some other text";
  check-equal("split #1",
              split(big-string, compile-regex("\\s")),
              #("The", "rain", "in", "spain", "and", "some", "other", "text"));
  check-equal("split #2",
              split(big-string, compile-regex("\\s"), count: 3),
              #("The", "rain", "in spain and some other text"));
  check-equal("split #3",
              split(big-string, compile-regex("\\s"), start: 12),
              #("spain", "and", "some", "other", "text"));
  check-equal("split #4",
              split(" Some   text with   lots of spaces  ",
                    compile-regex("\\s"),
                    count: 3),
              #("", "Some", "  text with   lots of spaces  "));
  check-equal("split #5",
              split(" Some   text with   lots of spaces  ",
                    compile-regex("\\s+")),
              #("", "Some", "text", "with", "lots", "of", "spaces", ""));
end test split-test;

define test atom-test ()
  check-matches("", "", "");
  check-matches("a", "a", "a");
  check-matches("[a]", "a", "a");
  check-matches("(a)b", "ab", "ab", "a");
  check-matches("\\w", "a", "a");
  check-matches(".", "a", "a");
  check-matches("a{0}", "a", "");
  check-matches("a{2}", "aa", "aa");
  check-matches("a{1,}", "aa", "aa");
  check-matches("a{1,8}", "aaa", "aaa");
  check-matches("a{1,2}", "aaa", "aa");
  check-matches("a{,}", "", "");
  check-matches("a{,}", "aaaaaa", "aaaaaa");
end test atom-test;

// These are to cover the basics, as I add new features to the code or
// read through the pcrepattern docs.  The PCRE tests should cover a lot
// of the more esoteric cases, I hope.
//
define test ad-hoc-regex-test ()
  //args: check-matches(regex, string, group1, group2, ..., flag1: x, flag2: y, ...)
  check-matches("", "abc", "");
  check-matches("a()b", "ab", "ab", "");
  check-matches("a(?#blah)b", "ab", "ab"); // comments shouldn't create a group
  check-matches(".", "x", "x");
  check-matches(".", "\n", "\n", dot-matches-all: #t);
  check-matches("[a-]", "-", "-");
  check-matches("(x)y", "xy", "xy", "x");
  check-matches("((x)y)", "xy", "xy", "xy", "x");
  check-matches("^(([^:/?#]+):)?(//((([^/?#]*)@)?([^/?#:]*)(:([^/?#]*))?))?([^?#]*)(\\?([^#]*))?(#(.*))?",
                "http://localhost/",
                // groups...
                "http://localhost/", "http:", "http", "//localhost", "localhost",
                #f, #f, "localhost", #f, #f, "/", #f, #f, #f);
  check-equal("start: works?",
              regex-search(compile-regex("a"), "a b c", start: 1),
              #f);
  check-equal("end: works?",
              regex-search(compile-regex("c"), "a b c", end: 4),
              #f);
  check-equal("start: and end: work?",
              regex-search(compile-regex("a"), "a b a", start: 1, end: 4),
              #f);
  check-equal("atom-tan", "\<44>\<79>\<6c>\<61>\<6e>", "Dylan");
end test ad-hoc-regex-test;

// All these regexes should signal <invalid-regex> on compilation.
//
define test invalid-regex-test ()
  let patterns = #(
    "(?P<foo>x)(?P<foo>y)",           // can't use same group name twice
    "(?@abc)",                        // invalid extended character '@'
    "(a)\\2",                         // invalid back reference
    "a{m,n}",
    "a{m,}",
    "a{,n}",
    "a{m}",
    "a{,",
    "[a",
    "(",
    "(()",
    "((a)b|"
    );
  for (pattern in patterns)
    check-condition(format-to-string("Compiling '%s' gets an error", pattern),
                    <invalid-regex>,
                    compile-regex(pattern));
  end;
end test invalid-regex-test;

// TODO(cgay): Commented out until https://github.com/dylan-lang/testworks/issues/98
// is fixed.

// define test pcre-testoutput1 ()
//   run-pcre-checks(make-pcre-locator("pcre-testoutput1.txt"));
// end;

// define suite pcre-test-suite ()
//   test pcre-testoutput1;
// end;

// define test regressions-test ()
//   run-pcre-checks(make-pcre-locator("regression-tests.txt"));
// end;
