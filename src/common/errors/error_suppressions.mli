(**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

type t

val empty: t

(* Raises if the given loc has `source` set to `None` *)
val add: Loc.t -> t -> t
val add_lint_suppressions: Utils_js.LocSet.t -> t -> t

val remove: File_key.t -> t -> t

(* Union the two collections of suppressions. If they both contain suppressions for a given file,
 * include both sets of suppressions. *)
val union: t -> t -> t
(* Union the two collections of suppressions. If they both contain suppressions for a given file,
 * discard those included in the first argument. *)
val update_suppressions: t -> t -> t

val all_locs: t -> Loc.t list

val filter_suppressed_errors :
  t -> Errors.ConcreteLocErrorSet.t -> unused:t ->
  (Errors.ConcreteLocErrorSet.t * (Loc.t Errors.error * Utils_js.LocSet.t) list * t)

(* We use an ErrorSet here (as opposed to a ConcreteErrorSet) because this operation happens
   during merge rather than during collation as filter_suppressed_errors does *)
val filter_lints : t -> Errors.ErrorSet.t -> include_suppressions:bool ->
  ExactCover.lint_severity_cover Utils_js.FilenameMap.t ->
  (Errors.ErrorSet.t * Errors.ErrorSet.t * t)

val get_lint_settings : 'a ExactCover.t Utils_js.FilenameMap.t -> Loc.t -> 'a option
