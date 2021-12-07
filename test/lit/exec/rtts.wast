;; NOTE: Assertions have been generated by update_lit_checks.py --output=fuzz-exec and should not be edited.

;; Check that allocation and casting instructions with and without RTTs can be
;; mixed correctly.

;; RUN: wasm-opt %s -all --fuzz-exec-before -q --structural -o /dev/null 2>&1 \
;; RUN:   | filecheck %s --check-prefix=EQREC

;; RUN: wasm-opt %s -all --fuzz-exec-before -q --nominal -o /dev/null 2>&1 \
;; RUN:   | filecheck %s --check-prefix=NOMNL

(module
  (type $struct (struct_subtype i32 data))
  (type $sub-struct (struct_subtype i32 i32 $struct))

  (import "fuzzing-support" "log-i32" (func $log (param i32)))

  (global $sub-rtt (rtt 1 $sub-struct)
    (rtt.sub $sub-struct
      (rtt.canon $struct)
    )
  )

  (func $make-sub-struct-canon (result (ref $struct))
    (struct.new_default_with_rtt $sub-struct
      (rtt.canon $sub-struct)
    )
  )

  (func $make-sub-struct-sub (result (ref $struct))
    (struct.new_default_with_rtt $sub-struct
      (global.get $sub-rtt)
    )
  )

  (func $make-sub-struct-static (result (ref $struct))
    (struct.new_default $sub-struct)
  )

  ;; EQREC:      [fuzz-exec] calling canon-canon
  ;; EQREC-NEXT: [LoggingExternalInterface logging 1]
  ;; NOMNL:      [fuzz-exec] calling canon-canon
  ;; NOMNL-NEXT: [LoggingExternalInterface logging 1]
  (func "canon-canon"
    (call $log
      (ref.test
        (call $make-sub-struct-canon)
        (rtt.canon $sub-struct)
      )
    )
  )

  ;; EQREC:      [fuzz-exec] calling canon-sub
  ;; EQREC-NEXT: [LoggingExternalInterface logging 0]
  ;; NOMNL:      [fuzz-exec] calling canon-sub
  ;; NOMNL-NEXT: [LoggingExternalInterface logging 1]
  (func "canon-sub"
    (call $log
      (ref.test
        (call $make-sub-struct-canon)
        (global.get $sub-rtt)
      )
    )
  )

  ;; EQREC:      [fuzz-exec] calling canon-static
  ;; EQREC-NEXT: [LoggingExternalInterface logging 1]
  ;; NOMNL:      [fuzz-exec] calling canon-static
  ;; NOMNL-NEXT: [LoggingExternalInterface logging 1]
  (func "canon-static"
    (call $log
      (ref.test_static $sub-struct
        (call $make-sub-struct-canon)
      )
    )
  )

  ;; EQREC:      [fuzz-exec] calling sub-canon
  ;; EQREC-NEXT: [LoggingExternalInterface logging 0]
  ;; NOMNL:      [fuzz-exec] calling sub-canon
  ;; NOMNL-NEXT: [LoggingExternalInterface logging 1]
  (func "sub-canon"
    (call $log
      (ref.test
        (call $make-sub-struct-sub)
        (rtt.canon $sub-struct)
      )
    )
  )

  ;; EQREC:      [fuzz-exec] calling sub-sub
  ;; EQREC-NEXT: [LoggingExternalInterface logging 1]
  ;; NOMNL:      [fuzz-exec] calling sub-sub
  ;; NOMNL-NEXT: [LoggingExternalInterface logging 1]
  (func "sub-sub"
    (call $log
      (ref.test
        (call $make-sub-struct-sub)
        (global.get $sub-rtt)
      )
    )
  )

  ;; EQREC:      [fuzz-exec] calling sub-static
  ;; EQREC-NEXT: [LoggingExternalInterface logging 0]
  ;; NOMNL:      [fuzz-exec] calling sub-static
  ;; NOMNL-NEXT: [LoggingExternalInterface logging 1]
  (func "sub-static"
    (call $log
      (ref.test_static $sub-struct
        (call $make-sub-struct-sub)
      )
    )
  )

  ;; EQREC:      [fuzz-exec] calling static-canon
  ;; EQREC-NEXT: [LoggingExternalInterface logging 1]
  ;; NOMNL:      [fuzz-exec] calling static-canon
  ;; NOMNL-NEXT: [LoggingExternalInterface logging 1]
  (func "static-canon"
    (call $log
      (ref.test
        (call $make-sub-struct-static)
        (rtt.canon $sub-struct)
      )
    )
  )

  ;; EQREC:      [fuzz-exec] calling static-sub
  ;; EQREC-NEXT: [LoggingExternalInterface logging 0]
  ;; NOMNL:      [fuzz-exec] calling static-sub
  ;; NOMNL-NEXT: [LoggingExternalInterface logging 1]
  (func "static-sub"
    (call $log
      (ref.test
        (call $make-sub-struct-static)
        (global.get $sub-rtt)
      )
    )
  )

  ;; EQREC:      [fuzz-exec] calling static-static
  ;; EQREC-NEXT: [LoggingExternalInterface logging 1]
  ;; NOMNL:      [fuzz-exec] calling static-static
  ;; NOMNL-NEXT: [LoggingExternalInterface logging 1]
  (func "static-static"
    (call $log
      (ref.test_static $sub-struct
        (call $make-sub-struct-static)
      )
    )
  )
)
