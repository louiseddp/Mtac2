From Mtac2 Require Import Mtac2.
Import M.
Import M.notations.

Print Universes "universes-mtac2.txt".
Import M.
Require Import Coq.Numbers.BinNums.
Require Import Strings.String.

Definition file := "universes-mtac2.txt".
Definition magic_number := "0".

(* we look for whaterever universes from Coq is < or <= than one of Mtac's *)
Definition find_cmd := "egrep ""Coq.*Mtac2"" " ++ file.

(* we count the lines (we get one for each pair of universes found above).
   we also remove spaces since in Mac Os (apparently) wc returns spaces. *)
Definition count_cmd := find_cmd ++ " | wc -l  | tr -d ' '".

(* we test the result of the previous command to be equal to the actual number of
   universes we expect to be in the list. currenlty, only those from ex *)
Definition assert_cmd := "[ $(" ++ count_cmd ++ ") = """ ++ magic_number ++ """ ]".

Definition cmd := Eval compute in eval (print assert_cmd;; ret assert_cmd).
Eval compute in eval (os_cmd count_cmd).
Definition is_linux := "[ $(uname) = ""Linux"" ] ".

Goal eval (os_cmd is_linux >>= fun x=>match x with
     | Z0 => M.print "Running test";; os_cmd cmd
     | _ => M.print "Not running test";; M.ret Z0
     end) = Z0.
  reflexivity.
Qed.

(* erase the file created *)
Goal eval (os_cmd ("rm " ++ file)) = Z0.
  reflexivity.
Qed.
