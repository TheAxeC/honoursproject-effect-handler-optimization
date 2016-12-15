type ('eff_arg, 'eff_res) effect = ..

type 'a computation =
  | Value : 'a -> 'a computation
  | Call :
      ('eff_arg, 'eff_res) effect * 'eff_arg * ('eff_res -> 'a computation)
        -> 'a computation

type ('a, 'b) value_clause = 'a -> 'b computation

type ('a, 'b) finally_clause = 'a -> 'b computation

type ('eff_arg, 'eff_res, 'b) effect_clauses =
      (('eff_arg, 'eff_res) effect ->
      ('eff_arg -> ('eff_res -> 'b computation) -> 'b computation))

type ('a, 'b, 'c) handler =
  { value_clause : ('a, 'b) value_clause;
    finally_clause : ('b, 'c) finally_clause;
    effect_clauses : 'eff_arg 'eff_res. ('eff_arg, 'eff_res, 'b) effect_clauses
  }



let rec ( >> ) (c : 'a computation) (f : 'a -> 'b computation) =
  match c with
  | Value x -> f x
  | Call (eff, arg, k) -> Call (eff, arg, (fun y -> (k y) >> f))

let rec handle (h : ('a, 'b, 'c) handler) (c : 'a computation) :
  'c computation =
  let rec handler =
    function
    | Value x -> h.value_clause x
    | Call (eff, arg, k) ->
        let clause = h.effect_clauses eff
        in clause arg (fun y -> handler (k y))
  in (handler c) >> h.finally_clause

let value (x : 'a) : 'a computation = Value x

let call (eff : ('a, 'b) effect) (arg : 'a) (cont : 'b -> 'c computation) :
  'c computation = Call (eff, arg, cont)

let effect eff arg = call eff arg value

let run =
  function
  | Value x -> x
  | Call (eff, _, _) -> failwith ("Uncaught effect")

let (=) = fun x -> value (fun y -> value (Pervasives.(=) x y))
let (<) = fun x -> value (fun y -> value (Pervasives.(<) x y))
let (<>) = fun x -> value (fun y -> value (Pervasives.(<>) x y))
let (>) = fun x -> value (fun y -> value (Pervasives.(>) x y))

let (>=) = fun x -> value (fun y -> value (Pervasives.(>=) x y))
let (<=) = fun x -> value (fun y -> value (Pervasives.(<=) x y))
let (!=) = fun x -> value (fun y -> value (Pervasives.(!=) x y))

let (~-) = fun x -> value (Pervasives.(~-) x)
let (+) = fun x -> value (fun y -> value (Pervasives.(+) x y))
let ( * ) = fun x -> value (fun y -> value (Pervasives.( * ) x y))
let (-) = fun x -> value (fun y -> value (Pervasives.(-) x y))
let (mod) = fun x -> value (fun y -> value (Pervasives.(mod) x y))
let (~-.) = fun x -> value (Pervasives.(~-.) x)
let (+.) = fun x -> value (fun y -> value (Pervasives.(+.) x y))
let ( *. ) = fun x -> value (fun y -> value (Pervasives.( *. ) x y))
let (-.) = fun x -> value (fun y -> value (Pervasives.(-.) x y))
let (/.) = fun x -> value (fun y -> value (Pervasives.(/.) x y))
let (/) = fun x -> value (fun y -> value (Pervasives.(/) x y))
let ( ** ) =
  let rec pow a = Pervasives.(function
  | 0 -> 1
  | 1 -> a
  | n ->
    let b = pow a (n / 2) in
    b * b * (if n mod 2 = 0 then 1 else a)) in
  fun x -> value (fun y -> value (pow x y))

let float_of_int = fun x -> value (Pervasives.float_of_int x)
let (^) = fun x -> value (fun y -> value (Pervasives.(^) x y))
let string_length = fun x -> value (String.length x)
let to_string = fun _ -> failwith "Not implemented"

;;
let _var_1 (* = *) : ('t25 -> (('t25 -> ( bool) computation)) computation) = ( = )

;;


let _var_2 (* < *) : ('t26 -> (('t26 -> ( bool) computation)) computation) = ( < )

;;


let _var_3 (* > *) : ('t27 -> (('t27 -> ( bool) computation)) computation) = ( > )

;;


let _var_4 (* <> *) : ('t28 -> (('t28 -> ( bool) computation)) computation) = ( <> )

;;


let _var_5 (* <= *) : ('t29 -> (('t29 -> ( bool) computation)) computation) = ( <= )

;;


let _var_6 (* >= *) : ('t30 -> (('t30 -> ( bool) computation)) computation) = ( >= )

;;


let _var_7 (* != *) : ('t31 -> (('t31 -> ( bool) computation)) computation) = ( != )

;;


type (_, _) effect += Effect_Print : ( string,  unit) effect

;;


type (_, _) effect += Effect_Read : ( unit,  string) effect

;;


type (_, _) effect += Effect_Raise : ( unit, unit) effect

;;


let _absurd_8 = (fun _void_9 ->
   (match _void_9 with _ -> assert false))

;;


type (_, _) effect += Effect_DivisionByZero : ( unit, unit) effect

;;


type (_, _) effect += Effect_InvalidArgument : ( string, unit) effect

;;


type (_, _) effect += Effect_Failure : ( string, unit) effect

;;


let _failwith_10 = (fun _msg_11 ->
   call Effect_Failure _msg_11 (fun _result_27 ->  _absurd_8 _result_27))

;;


type (_, _) effect += Effect_AssertionFault : ( unit, unit) effect

;;


let _assert_13 = (fun _b_14 ->
   (match _b_14 with | true ->
                        value ()
                     | false ->
                        call Effect_AssertionFault () (fun _result_30 ->
                                                          _absurd_8
                                                       _result_30)))

;;


let _var_16 (* ~- *) : ( int -> ( int) computation) = ( ~- )

;;


let _var_17 (* + *) : ( int -> (( int -> ( int) computation)) computation) = ( + )

;;


let _var_18 (* * *) : ( int -> (( int -> ( int) computation)) computation) = ( * )

;;


let _var_19 (* - *) : ( int -> (( int -> ( int) computation)) computation) = ( - )

;;


let _mod_20 : ( int -> (( int -> ( int) computation)) computation) = ( mod )

;;


let _mod_21 = (fun _m_22 ->  value (fun _n_23 ->
   (match _n_23 with | 0 ->
                        call Effect_DivisionByZero () (fun _result_33 ->
                                                          _absurd_8
                                                       _result_33)
                     | _n_25 ->
                        value (Pervasives.(mod)
                     _m_22
                     _n_25))))

;;


let _var_27 (* ~-. *) : ( float -> ( float) computation) = ( ~-. )

;;


let _var_28 (* +. *) : ( float -> (( float -> ( float) computation)) computation) = ( +. )

;;


let _var_29 (* *. *) : ( float -> (( float -> ( float) computation)) computation) = ( *. )

;;


let _var_30 (* -. *) : ( float -> (( float -> ( float) computation)) computation) = ( -. )

;;


let _var_31 (* /. *) : ( float -> (( float -> ( float) computation)) computation) = ( /. )

;;


let _var_32 (* / *) : ( int -> (( int -> ( int) computation)) computation) = ( / )

;;


let _var_33 (* ** *) : ( int -> (( int -> ( int) computation)) computation) = ( ** )

;;


let _var_34 (* / *) = (fun _m_35 ->  value (fun _n_36 ->
   (match _n_36 with | 0 ->
                        call Effect_DivisionByZero () (fun _result_36 ->
                                                          _absurd_8
                                                       _result_36)
                     | _n_38 ->
                        value (Pervasives.(/)
                     _m_35
                     _n_38))))

;;


let _float_of_int_40 : ( int -> ( float) computation) = ( float_of_int )

;;


let _var_41 (* ^ *) : ( string -> (( string -> ( string) computation)) computation) = ( ^ )

;;


let _string_length_42 : ( string -> ( int) computation) = ( string_length )

;;


let _to_string_43 : ('t32 -> ( string) computation) = ( to_string )

;;


type ('t33) option = None|Some of 't33

;;

let rec _assoc_44 = fun _x_45 ->
   value (fun _gen_function_46 ->
   (match _gen_function_46 with | [] ->
                                   value None
                                | (((_y_47, _z_48)) :: (_lst_49)) ->
                                   (match Pervasives.(=)
                                _x_45
                                _y_47 with | true ->
                                              value ((Some _z_48))
                                           | false ->
                                              (_assoc_44 _x_45) >>
                                              fun _gen_bind_52 ->
                                                 _gen_bind_52
                                              _lst_49)))

;;


let _not_53 = (fun _x_54 ->
   (match _x_54 with | true ->
                        value false
                     | false ->
                        value true))

;;

let rec _range_55 = fun _m_56 ->
   value (fun _n_57 ->  (match Pervasives.(>) _m_56
_n_57 with | true ->
              value []
           | false ->
              (_range_55 (Pervasives.(+) _m_56 1)) >>
              fun _gen_bind_62 ->
                 (_gen_bind_62 _n_57) >>
                 fun _gen_bind_61 ->  value (((::) (_m_56, _gen_bind_61)))))

;;


let rec _map_65 = fun _f_66 ->  value (fun _gen_function_67 ->
   (match _gen_function_67 with | [] ->
                                   value []
                                | ((_x_68) :: (_xs_69)) ->
                                   (_f_66 _x_68) >>
                                   fun _y_70 ->
                                      (_map_65 _f_66) >>
                                      fun _gen_bind_72 ->
                                         (_gen_bind_72 _xs_69) >>
                                         fun _ys_71 ->
                                            value (((::) (_y_70, _ys_71)))))

;;


let _ignore_73 = (fun _ ->  value ())

;;

let _take_74 = (fun _f_75 ->
   value (fun _k_76 ->
   (_range_55 0) >>
   fun _gen_bind_78 ->
      (_gen_bind_78 _k_76) >>
      fun _r_77 ->
         (_map_65 _f_75) >> fun _gen_bind_79 ->  _gen_bind_79 _r_77))

;;


let rec _fold_left_80 = fun _f_81 ->  value (fun _a_82 ->
   value (fun _gen_function_83 ->
   (match _gen_function_83 with | [] ->
                                   value _a_82
                                | ((_y_84) :: (_ys_85)) ->
                                   (_f_81 _a_82) >>
                                   fun _gen_bind_87 ->
                                      (_gen_bind_87 _y_84) >>
                                      fun _a_86 ->
                                         (_fold_left_80 _f_81) >>
                                         fun _gen_bind_89 ->
                                            (_gen_bind_89 _a_86) >>
                                            fun _gen_bind_88 ->  _gen_bind_88
                                            _ys_85)))

;;


let rec _fold_right_90 = fun _f_91 ->  value (fun _xs_92 ->
   value (fun _a_93 ->
   (match _xs_92 with | [] ->
                         value _a_93
                      | ((_x_94) :: (_xs_95)) ->
                         (_fold_right_90 _f_91) >>
                         fun _gen_bind_98 ->
                            (_gen_bind_98 _xs_95) >>
                            fun _gen_bind_97 ->
                               (_gen_bind_97 _a_93) >>
                               fun _a_96 ->
                                  (_f_91 _x_94) >>
                                  fun _gen_bind_99 ->  _gen_bind_99 _a_96)))

;;


let rec _iter_100 = fun _f_101 ->  value (fun _gen_function_102 ->
   (match _gen_function_102 with | [] ->
                                    value ()
                                 | ((_x_103) :: (_xs_104)) ->
                                    (_f_101 _x_103) >>
                                    fun _ ->
                                       (_iter_100 _f_101) >>
                                       fun _gen_bind_105 ->  _gen_bind_105
                                       _xs_104))

;;


let rec _forall_106 = fun _p_107 ->  value (fun _gen_function_108 ->
   (match _gen_function_108 with | [] ->
                                    value true
                                 | ((_x_109) :: (_xs_110)) ->
                                    (_p_107 _x_109) >>
                                    fun _gen_bind_111 ->
                                       (match _gen_bind_111 with | true ->
                                                                    (_forall_106
                                                                    _p_107)
                                                                    >>
                                                                    fun _gen_bind_112 ->
                                                                     _gen_bind_112
                                                                    _xs_110
                                                                 | false ->
                                                                    value false)))

;;


let rec _exists_113 = fun _p_114 ->  value (fun _gen_function_115 ->
   (match _gen_function_115 with | [] ->
                                    value false
                                 | ((_x_116) :: (_xs_117)) ->
                                    (_p_114 _x_116) >>
                                    fun _gen_bind_118 ->
                                       (match _gen_bind_118 with | true ->
                                                                    value true
                                                                 | false ->
                                                                    (_exists_113
                                                                    _p_114)
                                                                    >>
                                                                    fun _gen_bind_119 ->
                                                                     _gen_bind_119
                                                                    _xs_117)))

;;


let _mem_120 = (fun _x_121 ->  _exists_113 (fun _x'_122 ->
   value (Pervasives.(=) _x_121 _x'_122)))

;;


let rec _filter_124 = fun _p_125 ->  value (fun _gen_function_126 ->
   (match _gen_function_126 with | [] ->
                                    value []
                                 | ((_x_127) :: (_xs_128)) ->
                                    (_p_125 _x_127) >>
                                    fun _gen_bind_129 ->
                                       (match _gen_bind_129 with | true ->
                                                                    (_filter_124
                                                                    _p_125)
                                                                    >>
                                                                    fun _gen_bind_131 ->

                                                                    (_gen_bind_131
                                                                    _xs_128)
                                                                    >>
                                                                    fun _gen_bind_130 ->
                                                                     value (((::) (
                                                                    _x_127,
                                                                    _gen_bind_130)))
                                                                 | false ->
                                                                    (_filter_124
                                                                    _p_125)
                                                                    >>
                                                                    fun _gen_bind_132 ->
                                                                     _gen_bind_132
                                                                    _xs_128)))

;;


let _complement_133 = (fun _xs_134 ->  value (fun _ys_135 ->
   (_filter_124 (fun _x_137 ->
      (_mem_120 _x_137) >>
      fun _gen_bind_139 ->
         (_gen_bind_139 _ys_135) >>
         fun _gen_bind_138 ->  _not_53 _gen_bind_138)) >>
   fun _gen_bind_136 ->  _gen_bind_136 _xs_134))

;;


let _intersection_140 = (fun _xs_141 ->  value (fun _ys_142 ->
   (_filter_124 (fun _x_144 ->
      (_mem_120 _x_144) >> fun _gen_bind_145 ->  _gen_bind_145 _ys_142)) >>
   fun _gen_bind_143 ->  _gen_bind_143 _xs_141))

;;


let rec _zip_146 = fun _xs_147 ->  value (fun _ys_148 ->
   (match (_xs_147, _ys_148) with | ([], []) ->
                                     value []
                                  | (((_x_149) :: (_xs_150)),
                                     ((_y_151) :: (_ys_152))) ->
                                     (_zip_146 _xs_150) >>
                                     fun _gen_bind_154 ->
                                        (_gen_bind_154 _ys_152) >>
                                        fun _gen_bind_153 ->
                                           value (((::) ((_x_149, _y_151),
                                                         _gen_bind_153)))
                                  | (_, _) ->
                                     call Effect_InvalidArgument "zip: length mismatch" (
                                  fun _result_45 ->  _absurd_8 _result_45)))

;;


let _reverse_156 = (fun _lst_157 ->
   let rec _reverse_acc_158 = fun _acc_159 ->
              value (fun _gen_function_160 ->
              (match _gen_function_160 with | [] ->
                                               value _acc_159
                                            | ((_x_161) :: (_xs_162)) ->
                                               (_reverse_acc_158
                                               (((::) (_x_161, _acc_159))))
                                               >>
                                               fun _gen_bind_163 ->
                                                  _gen_bind_163
                                               _xs_162)) in (_reverse_acc_158
                                                            []) >>
                                                            fun _gen_bind_164 ->
                                                               _gen_bind_164
                                                            _lst_157)

;;


let rec _var_165 (* @ *) = fun _xs_166 ->  value (fun _ys_167 ->
   (match _xs_166 with | [] ->
                          value _ys_167
                       | ((_x_168) :: (_xs_169)) ->
                          (_var_165 (* @ *) _xs_169) >>
                          fun _gen_bind_171 ->
                             (_gen_bind_171 _ys_167) >>
                             fun _gen_bind_170 ->
                                value (((::) (_x_168, _gen_bind_170)))))

;;


let rec _length_172 = fun _gen_let_rec_function_173 ->
   (match _gen_let_rec_function_173 with | [] ->
                                            value 0
                                         | ((_x_174) :: (_xs_175)) ->
                                            (_length_172 _xs_175) >>
                                            fun _gen_bind_177 ->
                                               value (Pervasives.(+)
                                            _gen_bind_177 1))

;;


let _head_178 = (fun _gen_function_179 ->
   (match _gen_function_179 with | [] ->
                                    call Effect_InvalidArgument "head: empty list" (
                                 fun _result_48 ->  _absurd_8 _result_48)
                                 | ((_x_181) :: (_)) ->
                                    value _x_181))

;;


let _tail_182 = (fun _gen_function_183 ->
   (match _gen_function_183 with | [] ->
                                    call Effect_InvalidArgument "tail: empty list" (
                                 fun _result_51 ->  _absurd_8 _result_51)
                                 | ((_x_185) :: (_xs_186)) ->
                                    value _xs_186))

;;


let _hd_187 = _head_178

;;

let _tl_188 = _tail_182

;;


let _abs_189 = (fun _x_190 ->  (match Pervasives.(<) _x_190
0 with | true ->
          value (Pervasives.(~-)
       _x_190)
       | false ->
          value _x_190))

;;

let _min_193 = (fun _x_194 ->
   value (fun _y_195 ->  (match Pervasives.(<) _x_194
_y_195 with | true ->
               value _x_194
            | false ->
               value _y_195)))

;;

let _max_198 = (fun _x_199 ->
   value (fun _y_200 ->  (match Pervasives.(<) _x_199
_y_200 with | true ->
               value _y_200
            | false ->
               value _x_199)))

;;

let rec _gcd_203 = fun _m_204 ->
   value (fun _n_205 ->
   (match _n_205 with | 0 ->
                         value _m_204
                      | _ ->
                         (_gcd_203 _n_205) >>
                         fun _g_206 ->
                            (_mod_21 _m_204) >>
                            fun _gen_bind_208 ->
                               (_gen_bind_208 _n_205) >>
                               fun _gen_bind_207 ->  _g_206 _gen_bind_207))

;;


let rec _lcm_209 = fun _m_210 ->  value (fun _n_211 ->
   (_gcd_203 _m_210) >>
   fun _gen_bind_213 ->
      (_gen_bind_213 _n_211) >>
      fun _d_212 ->
         (_var_34 (* / *) (Pervasives.( * ) _m_210 _n_211)) >>
         fun _gen_bind_214 ->  _gen_bind_214 _d_212)

;;


let _odd_217 = (fun _x_218 ->
   (_mod_21 _x_218) >>
   fun _gen_bind_221 ->
      (_gen_bind_221 2) >>
      fun _gen_bind_220 ->  value (Pervasives.(=) _gen_bind_220 1))

;;


let _even_222 = (fun _x_223 ->
   (_mod_21 _x_223) >>
   fun _gen_bind_226 ->
      (_gen_bind_226 2) >>
      fun _gen_bind_225 ->  value (Pervasives.(=) _gen_bind_225 0))

;;


let _id_227 = (fun _x_228 ->  value _x_228)

;;


let _compose_229 = (fun _f_230 ->  value (fun _g_231 ->  value (fun _x_232 ->
   (_g_231 _x_232) >> fun _gen_bind_233 ->  _f_230 _gen_bind_233)))

;;


let _fst_234 = (fun (_x_235, _) ->  value _x_235)

;;


let _snd_236 = (fun (_, _y_237) ->  value _y_237)

;;


let _print_238 = (fun _v_239 ->
   (_to_string_43 _v_239) >>
   fun _s_240 ->
      call Effect_Print _s_240 (fun _result_63 ->  value _result_63))

;;


let _print_string_241 = (fun _str_242 ->
   call Effect_Print _str_242 (fun _result_65 ->  value _result_65))

;;


let _print_endline_243 = (fun _v_244 ->
   (_to_string_43 _v_244) >>
   fun _s_245 ->
      call Effect_Print _s_245 (fun _result_70 ->
                                   call Effect_Print "\n" (fun _result_67 ->
                                                              value _result_67)))

;;


type (_, _) effect += Effect_Lookup : ( unit,  int) effect

;;


type (_, _) effect += Effect_Update : ( int,  unit) effect

;;


let _state_246 = (fun _r_247 ->  value (fun _x_248 ->
   value { value_clause = (fun _y_256 ->  value (fun _ ->  value _y_256));
          finally_clause = (fun _f_255 ->  _f_255 _x_248);
          effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_Lookup -> (fun (() :  unit) (_k_252 :  int -> _ computation) -> value (fun _s_253 ->
             (_k_252 _s_253) >> fun _gen_bind_254 ->  _gen_bind_254 _s_253)) | Effect_Update -> (fun (_s'_249 :  int) (_k_250 :  unit -> _ computation) -> value (fun _ ->
             (_k_250 ()) >> fun _gen_bind_251 ->  _gen_bind_251 _s'_249)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) }))

;;


value "End of pervasives"

;;

type  num =  int

;;


type  func = ( int -> ( int) computation)

;;

type  loc =  int

;;


type  name =  string

;;

type  env = (( string* int)) list

;;


type  term = Num of ( int)|Add of (( term* term))|Mul of (( term* term))|
             Sub of (( term* term))|Div of (( term* term))|Ref of ( term)|
             Deref of ( term)|Assign of (( term* term))|Var of ( string)|
             App of (( termF* term))|Amb of (( term) list)
and

 termF = LambdaN of (( string* term))|LambdaV of (( string* term))|
         LambdaL of (( string* term))

;;


type (_, _) effect += Effect_VarNotFound : ( unit, unit) effect

;;


type (_, _) effect += Effect_Err : ( string,  int) effect

;;


type (_, _) effect += Effect_Arith_DivByZero : ( unit,  int) effect

;;


type (_, _) effect += Effect_Merge : (( int) list,  int) effect

;;


type (_, _) effect += Effect_ReadEnv : ( unit,  env) effect

;;


type (_, _) effect += Effect_InEnv : (( env* int),  int) effect

;;


type (_, _) effect += Effect_SetEnv : ( env,  env) effect

;;


type (_, _) effect += Effect_AllocLoc : ( unit,  loc) effect

;;


type (_, _) effect += Effect_LookupLoc : ( loc,  int) effect

;;


type (_, _) effect += Effect_UpdateLoc : (( loc* int),  loc) effect

;;


type (_, _) effect += Effect_Write : ( string,  unit) effect

;;


type (_, _) effect += Effect_Callcc : ( term,  int) effect

;;


let rec _lookupState_257 = fun _x_258 ->  value (fun _gen_function_259 ->
   (match _gen_function_259 with | [] ->
                                    call Effect_VarNotFound () (fun _result_73 ->
                                                                   _absurd_8
                                                                _result_73)
                                 | (((_x'_261, _y_262)) :: (_lst_263)) ->
                                    (match Pervasives.(=)
                                 _x_258
                                 _x'_261 with | true ->
                                                 value _y_262
                                              | false ->
                                                 (_lookupState_257 _x_258) >>
                                                 fun _gen_bind_266 ->
                                                    _gen_bind_266
                                                 _lst_263)))

;;


let _updateState_267 = (fun _k_268 ->  value (fun _v_269 ->
   value (fun _env_270 ->
   value (((::) ((_k_268, _v_269), _env_270))))))

;;


let rec _checkLoc_271 = fun _x_272 ->  value (fun _env_273 ->
   (match _env_273 with | [] ->
                           value false
                        | (((_x'_274, _y_275)) :: (_lst_276)) ->
                           (match Pervasives.(=)
                        _x_272
                        _x'_274 with | true ->
                                        value true
                                     | false ->
                                        (_checkLoc_271 _x_272) >>
                                        fun _gen_bind_279 ->  _gen_bind_279
                                        _lst_276)))

;;


let rec _createLoc_280 = fun _i_281 ->  value (fun _env_282 ->
   (_checkLoc_271 _i_281) >>
   fun _gen_bind_284 ->
      (_gen_bind_284 _env_282) >>
      fun _gen_bind_283 ->
         (match _gen_bind_283 with | true ->
                                      (_createLoc_280 (Pervasives.(+) _i_281
                                      1)) >>
                                      fun _gen_bind_285 ->  _gen_bind_285
                                      _env_282
                                   | false ->
                                      value _i_281))

;;


let _getNewLoc_288 = (fun _env_289 ->
   (_createLoc_280 0) >> fun _gen_bind_290 ->  _gen_bind_290 _env_289)

;;


let rec _lookupEnv_291 = fun _x_292 ->  value (fun _gen_function_293 ->
   (match _gen_function_293 with | [] ->
                                    call Effect_VarNotFound () (fun _result_80 ->
                                                                   _absurd_8
                                                                _result_80)
                                 | (((_x'_295, _y_296)) :: (_lst_297)) ->
                                    (match Pervasives.(=)
                                 _x_292
                                 _x'_295 with | true ->
                                                 value _y_296
                                              | false ->
                                                 (_lookupState_257 _x_292) >>
                                                 fun _gen_bind_300 ->
                                                    _gen_bind_300
                                                 _lst_297)))

;;


let _extendEnv_301 = (fun _k_302 ->  value (fun _v_303 ->
   value (fun _env_304 ->
   value (((::) ((_k_302, _v_303), _env_304))))))

;;


let rec _interpFunc_305 = fun _a_306 ->  value (fun _interpT_307 ->
   (match _a_306 with | (LambdaN (_s_308, _t_309)) ->
                         call Effect_ReadEnv () (fun _result_90 ->
                                                    value (fun _v_311 ->
                                                    (_extendEnv_301 _s_308)
                                                    >>
                                                    fun _gen_bind_314 ->
                                                       (_gen_bind_314 _v_311)
                                                       >>
                                                       fun _gen_bind_313 ->
                                                          (_gen_bind_313
                                                          _result_90) >>
                                                          fun _ext_312 ->
                                                             call Effect_SetEnv _ext_312 (
                                                          fun _result_87 ->
                                                             (_interpT_307
                                                             _t_309) >>
                                                             fun _gen_bind_316 ->
                                                                call Effect_InEnv (
                                                             _result_87,
                                                             _gen_bind_316) (
                                                             fun _result_84 ->
                                                                value _result_84))))
                      | (LambdaV (_s_317, _t_318)) ->
                         call Effect_ReadEnv () (fun _result_98 ->
                                                    value (fun _v_320 ->
                                                    (_extendEnv_301 _s_317)
                                                    >>
                                                    fun _gen_bind_323 ->
                                                       (_gen_bind_323 _v_320)
                                                       >>
                                                       fun _gen_bind_322 ->
                                                          (_gen_bind_322
                                                          _result_98) >>
                                                          fun _ext_321 ->
                                                             call Effect_SetEnv _ext_321 (
                                                          fun _result_95 ->
                                                             (_interpT_307
                                                             _t_318) >>
                                                             fun _gen_bind_325 ->
                                                                call Effect_InEnv (
                                                             _result_95,
                                                             _gen_bind_325) (
                                                             fun _result_92 ->
                                                                value _result_92))))
                      | (LambdaL (_s_326, _t_327)) ->
                         call Effect_ReadEnv () (fun _result_121 ->
                                                    value (fun _v_329 ->
                                                    call Effect_AllocLoc () (
                                                 fun _result_118 ->
                                                    call Effect_UpdateLoc (
                                                 _result_118, _v_329) (
                                                 fun _result_115 ->
                                                    call Effect_UpdateLoc (
                                                 _result_118, _v_329) (
                                                 fun _result_111 ->
                                                    (_extendEnv_301 _s_326)
                                                    >>
                                                    fun _gen_bind_335 ->
                                                       call Effect_LookupLoc _result_118 (
                                                    fun _result_107 ->
                                                       (_gen_bind_335
                                                       _result_107) >>
                                                       fun _gen_bind_108 ->
                                                          (_gen_bind_108
                                                          _result_121) >>
                                                          fun _ext_333 ->
                                                             call Effect_SetEnv _ext_333 (
                                                          fun _result_103 ->
                                                             (_interpT_307
                                                             _t_327) >>
                                                             fun _gen_bind_338 ->
                                                                call Effect_InEnv (
                                                             _result_103,
                                                             _gen_bind_338) (
                                                             fun _result_100 ->
                                                                value _result_100))))))))))

;;


let rec _interp_339 = fun _a_340 ->
   (match _a_340 with | (Num _b_341) ->
                         value _b_341
                      | (Add (_l_342, _r_343)) ->
                         (_interp_339 _l_342) >>
                         fun _gen_bind_345 ->
                            let _gen_bind_344 = fun _x2_23 ->
                                   value (Pervasives.(+) _gen_bind_345
                                _x2_23) in
                         (_interp_339 _r_343) >>
                         fun _gen_bind_346 ->  _gen_bind_344 _gen_bind_346
                      | (Mul (_l_347, _r_348)) ->
                         (_interp_339 _l_347) >>
                         fun _gen_bind_350 ->
                            let _gen_bind_349 = fun _x2_21 ->
                                   value (Pervasives.( * ) _gen_bind_350
                                _x2_21) in
                         (_interp_339 _r_348) >>
                         fun _gen_bind_351 ->  _gen_bind_349 _gen_bind_351
                      | (Sub (_l_352, _r_353)) ->
                         (_interp_339 _l_352) >>
                         fun _gen_bind_355 ->
                            let _gen_bind_354 = fun _x2_19 ->
                                   value (Pervasives.(-) _gen_bind_355
                                _x2_19) in
                         (_interp_339 _r_353) >>
                         fun _gen_bind_356 ->  _gen_bind_354 _gen_bind_356
                      | (Div (_l_357, _r_358)) ->
                         (_interp_339 _r_358) >>
                         fun _r_num_359 ->
                            (match _r_num_359 with | 0 ->
                                                      call Effect_Arith_DivByZero () (
                                                   fun _result_123 ->
                                                      value _result_123)
                                                   | _ ->
                                                      (_interp_339 _l_357) >>
                                                      fun _gen_bind_361 ->
                                                         (_var_34 (* / *)
                                                         _gen_bind_361) >>
                                                         fun _gen_bind_360 ->
                                                            _gen_bind_360
                                                         _r_num_359)
                      | (Ref _x_362) ->
                         (_interp_339 _x_362) >>
                         fun _x_interp_363 ->
                            call Effect_AllocLoc () (fun _result_128 ->
                                                        call Effect_UpdateLoc (
                                                     _result_128,
                                                     _x_interp_363) (
                                                     fun _result_125 ->
                                                        value _result_125))
                      | (Deref _x_365) ->
                         (_interp_339 _x_365) >>
                         fun _x_interp_366 ->
                            call Effect_LookupLoc _x_interp_366 (fun _result_130 ->
                                                                    value _result_130)
                      | (Assign (_lhs_367, _rhs_368)) ->
                         (_interp_339 _lhs_367) >>
                         fun _x_loc_369 ->
                            (_interp_339 _rhs_368) >>
                            fun _x_interp_370 ->
                               call Effect_UpdateLoc (_x_loc_369,
                                                      _x_interp_370) (
                            fun _result_133 ->  value _x_interp_370)
                      | (Var _v_371) ->
                         (_lookupEnv_291 _v_371) >>
                         fun _gen_bind_372 ->
                            (call Effect_ReadEnv () (fun _result_135 ->
                                                        value _result_135))
                            >>
                            fun _gen_bind_373 ->  _gen_bind_372 _gen_bind_373
                      | (App (_e1_374, _e2_375)) ->
                         (_interpFunc_305 _e1_374) >>
                         fun _gen_bind_377 ->
                            (_gen_bind_377 _interp_339) >>
                            fun _e1_interp_376 ->
                               call Effect_ReadEnv () (fun _result_144 ->
                                                          (_interp_339
                                                          _e2_375) >>
                                                          fun _e2_interp_379 ->
                                                             call Effect_SetEnv _result_144 (
                                                          fun _result_141 ->
                                                             call Effect_InEnv (
                                                          _result_141,
                                                          _e2_interp_379) (
                                                          fun _result_138 ->
                                                             _e1_interp_376
                                                          _result_138)))
                      | (Amb _t_382) ->
                         (_map_65 _interp_339) >>
                         fun _gen_bind_384 ->
                            (_gen_bind_384 _t_382) >>
                            fun _gen_bind_383 ->
                               call Effect_Merge _gen_bind_383 (fun _result_146 ->
                                                                   value _result_146))

;;


let rec _interpTopLevel_385 = fun _lst_386 ->  value (fun _results_387 ->
   (match _lst_386 with | [] ->
                           value _results_387
                        | ((_top_388) :: (_tail_389)) ->
                           (_interpTopLevel_385 _tail_389) >>
                           fun _gen_bind_390 ->
                              ((_var_165 (* @ *) _results_387) >>
                               fun _gen_bind_392 ->
                                  (_interp_339 _top_388) >>
                                  fun _gen_bind_393 ->  _gen_bind_392
                                  (((::) (_gen_bind_393, [])))) >>
                              fun _gen_bind_391 ->  _gen_bind_390
                              _gen_bind_391))

;;


let _arithmeticHandler_394 = { value_clause = (fun _gen_id_par_397 ->
                                                  value _gen_id_par_397);
                              finally_clause = (fun _gen_id_par_396 ->
                                                   value _gen_id_par_396);
                              effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_Arith_DivByZero -> (fun (() :  unit) (_k_395 :  int -> _ computation) -> value (Pervasives.(~-)
                              1)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) }

;;


let _storeHandler_398 = { value_clause = (fun _y_418 ->  value (fun _ ->
                                             value _y_418));
                         finally_clause = (fun _gen_id_par_417 ->
                                              value _gen_id_par_417);
                         effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_LookupLoc -> (fun (_x_411 :  loc) (_k_412 :  int -> _ computation) -> value (fun _s_413 ->
                            (_lookupState_257 _x_411) >>
                            fun _gen_bind_416 ->
                               (_gen_bind_416 _s_413) >>
                               fun _gen_bind_415 ->
                                  (_k_412 _gen_bind_415) >>
                                  fun _gen_bind_414 ->  _gen_bind_414 _s_413)) | Effect_UpdateLoc -> (fun ((
                         _x_403, _y_404) : ( loc*
                          int)) (_k_405 :  loc -> _ computation) -> value (fun _s_406 ->
                            (_k_405 _x_403) >>
                            fun _gen_bind_407 ->
                               ((_updateState_267 _x_403) >>
                                fun _gen_bind_410 ->
                                   (_gen_bind_410 _y_404) >>
                                   fun _gen_bind_409 ->  _gen_bind_409 _s_406)
                               >>
                               fun _gen_bind_408 ->  _gen_bind_407
                               _gen_bind_408)) | Effect_AllocLoc -> (fun (() :  unit) (_k_399 :  loc -> _ computation) -> value (fun _s_400 ->
                            (_getNewLoc_288 _s_400) >>
                            fun _gen_bind_402 ->
                               (_k_399 _gen_bind_402) >>
                               fun _gen_bind_401 ->  _gen_bind_401 _s_400)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) }

;;


let _environmentHandler_419 = { value_clause = (fun _y_431 ->
                                                   value (fun _ ->
                                                   value _y_431));
                               finally_clause = (fun _gen_id_par_430 ->
                                                    value _gen_id_par_430);
                               effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_InEnv -> (fun ((
                               _env_426, _s_427) : ( env*
                                int)) (_k_428 :  int -> _ computation) -> value (fun _ ->
                                  (_k_428 _s_427) >>
                                  fun _gen_bind_429 ->  _gen_bind_429
                                  _env_426)) | Effect_ReadEnv -> (fun (() :  unit) (_k_423 :  env -> _ computation) -> value (fun _env_424 ->
                                  (_k_423 _env_424) >>
                                  fun _gen_bind_425 ->  _gen_bind_425
                                  _env_424)) | Effect_SetEnv -> (fun (_env_420 :  env) (_k_421 :  env -> _ computation) -> value (fun _ ->
                                  (_k_421 _env_420) >>
                                  fun _gen_bind_422 ->  _gen_bind_422
                                  _env_420)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) }

;;


let _outputHandler_432 = { value_clause = (fun _gen_id_par_436 ->
                                              value _gen_id_par_436);
                          finally_clause = (fun _gen_id_par_435 ->
                                               value _gen_id_par_435);
                          effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_Write -> (fun (_s_433 :  string) (_k_434 :  unit -> _ computation) -> _k_434
                          ()) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) }

;;


let _errorHandler_437 = { value_clause = (fun _gen_id_par_441 ->
                                             value _gen_id_par_441);
                         finally_clause = (fun _gen_id_par_440 ->
                                              value _gen_id_par_440);
                         effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_Err -> (fun (_s_438 :  string) (_k_439 :  int -> _ computation) -> _k_439
                         0) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) }

;;


let _nondeterminismHandler_442 = { value_clause = (fun _gen_id_par_446 ->
                                                      value _gen_id_par_446);
                                  finally_clause = (fun _gen_id_par_445 ->
                                                       value _gen_id_par_445);
                                  effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_Merge -> (fun (_s_443 : ( int) list) (_k_444 :  int -> _ computation) -> _k_444
                                  0) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) }

;;


let _lambdaCase_447 = ((LambdaV ("a",
                                 (Add ((Add ((Add ((Var "a"), (Num 2))),
                                             (Add ((Num 1), (Num 2))))),
                                       (Add ((Add ((Num 1), (Num 2))),
                                             (Add ((Num 1), (Num 2))))))))))

;;


let _addCase_448 = ((Add ((Add ((Add ((Num 1), (Num 2))),
                                (Add ((Num 1), (Num 2))))),
                          (Add ((Add ((Num 1), (Num 2))),
                                (Add ((Num 1), (Num 2))))))))

;;


let _testCaseA_449 = ((App (_lambdaCase_447,
                            (App (_lambdaCase_447,
                                  (App (_lambdaCase_447,
                                        (App (_lambdaCase_447,
                                              (App (_lambdaCase_447,
                                                    (App (_lambdaCase_447,
                                                          (App (_lambdaCase_447,
                                                                _addCase_448)))))))))))))))

;;


let _testCaseB_450 = ((App (_lambdaCase_447,
                            (App (_lambdaCase_447,
                                  (App (_lambdaCase_447,
                                        (App (_lambdaCase_447,
                                              (App (_lambdaCase_447,
                                                    (App (_lambdaCase_447,
                                                          (App (_lambdaCase_447,
                                                                _testCaseA_449)))))))))))))))

;;


let _testCaseC_451 = ((App (_lambdaCase_447,
                            (App (_lambdaCase_447,
                                  (App (_lambdaCase_447,
                                        (App (_lambdaCase_447,
                                              (App (_lambdaCase_447,
                                                    (App (_lambdaCase_447,
                                                          (App (_lambdaCase_447,
                                                                _testCaseB_450)))))))))))))))

;;


let _testCaseD_452 = ((App (_lambdaCase_447,
                            (App (_lambdaCase_447,
                                  (App (_lambdaCase_447,
                                        (App (_lambdaCase_447,
                                              (App (_lambdaCase_447,
                                                    (App (_lambdaCase_447,
                                                          (App (_lambdaCase_447,
                                                                _testCaseC_451)))))))))))))))

;;


let rec _createCase_453 = fun _n_454 ->
   (match _n_454 with | 1 ->
                         value _testCaseD_452
                      | _ ->
                         (_createCase_453 (Pervasives.(-) _n_454 1)) >>
                         fun _gen_bind_455 ->
                            value ((App (_lambdaCase_447, _gen_bind_455))))

;;


let _finalCase_458 = run (_createCase_453 3000)

;;


let _test1_459 = run (_interp_339 ((Add ((Num 5), (Num 3)))))

;;

_assert_13
(Pervasives.(=) _test1_459 8)

;;


let _test2_462 = run (handle { value_clause = (fun _gen_id_par_150 ->
                                                  value _gen_id_par_150);
                              finally_clause = (fun _gen_id_par_149 ->
                                                   value _gen_id_par_149);
                              effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_Arith_DivByZero -> (fun (() :  unit) (_k_151 :  int -> _ computation) -> value (Pervasives.(~-)
                              1)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (_interp_339
((Div ((Num 5), (Num 0))))))

;;

_assert_13 (Pervasives.(=) _test2_462
(Pervasives.(~-) 1))

;;

let _test3_466 = run (let _s_231 = [] in
let _gen_bind_232 = fun _s_224 ->
       (_lookupState_257 1) >>
       fun _gen_bind_225 ->
          (_gen_bind_225 _s_224) >> fun _gen_bind_226 ->  value _gen_bind_226
    in
(_updateState_267 1) >>
fun _gen_bind_234 ->
   (_gen_bind_234 2) >>
   fun _gen_bind_235 ->
      (_gen_bind_235 _s_231) >>
      fun _gen_bind_233 ->  _gen_bind_232 _gen_bind_233)

;;

_assert_13
(Pervasives.(=) _test3_466 2)

;;


let _test4_471 = run ((handle { value_clause = (fun _ ->
                                                   handle { value_clause = (
                                                           fun _y_300 ->
                                                              value (fun _ ->
                                                              value _y_300));
                                                           finally_clause = (
                                                           fun _gen_id_par_299 ->
                                                              value _gen_id_par_299);
                                                           effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_LookupLoc -> (fun (_x_302 :  loc) (_k_301 :  int -> _ computation) -> value (fun _s_303 ->
                                                              (_lookupState_257
                                                              _x_302) >>
                                                              fun _gen_bind_304 ->
                                                                 (_gen_bind_304
                                                                 _s_303) >>
                                                                 fun _gen_bind_305 ->
                                                                    (_k_301
                                                                    _gen_bind_305)
                                                                    >>
                                                                    fun _gen_bind_306 ->
                                                                     _gen_bind_306
                                                                    _s_303)) | Effect_UpdateLoc -> (fun ((
                                                           _x_309, _y_308) : ( loc*
                                                            int)) (_k_307 :  loc -> _ computation) -> value (fun _s_310 ->
                                                              (_k_307 _x_309)
                                                              >>
                                                              fun _gen_bind_311 ->
                                                                 ((_updateState_267
                                                                  _x_309) >>
                                                                  fun _gen_bind_313 ->

                                                                  (_gen_bind_313
                                                                  _y_308) >>
                                                                  fun _gen_bind_314 ->
                                                                     _gen_bind_314
                                                                  _s_310) >>
                                                                 fun _gen_bind_312 ->
                                                                    _gen_bind_311
                                                                 _gen_bind_312)) | Effect_AllocLoc -> (fun (() :  unit) (_k_315 :  loc -> _ computation) -> value (fun _s_316 ->
                                                              (_getNewLoc_288
                                                              _s_316) >>
                                                              fun _gen_bind_317 ->
                                                                 (_k_315
                                                                 _gen_bind_317)
                                                                 >>
                                                                 fun _gen_bind_318 ->
                                                                    _gen_bind_318
                                                                 _s_316)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (_interp_339
                                                ((Deref (Num 1)))));
                               finally_clause = (fun _gen_id_par_298 ->
                                                    value _gen_id_par_298);
                               effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_LookupLoc -> (fun (_x_320 :  loc) (_k_319 :  int -> _ computation) -> value (fun _s_321 ->
                                  (_lookupState_257 _x_320) >>
                                  fun _gen_bind_322 ->
                                     (_gen_bind_322 _s_321) >>
                                     fun _gen_bind_323 ->
                                        (_k_319 _gen_bind_323) >>
                                        fun _gen_bind_324 ->  _gen_bind_324
                                        _s_321)) | Effect_UpdateLoc -> (fun ((
                               _x_327, _y_326) : ( loc*
                                int)) (_k_325 :  loc -> _ computation) -> value (fun _s_328 ->
                                  (_k_325 _x_327) >>
                                  fun _gen_bind_329 ->
                                     ((_updateState_267 _x_327) >>
                                      fun _gen_bind_331 ->
                                         (_gen_bind_331 _y_326) >>
                                         fun _gen_bind_332 ->  _gen_bind_332
                                         _s_328) >>
                                     fun _gen_bind_330 ->  _gen_bind_329
                                     _gen_bind_330)) | Effect_AllocLoc -> (fun (() :  unit) (_k_333 :  loc -> _ computation) -> value (fun _s_334 ->
                                  (_getNewLoc_288 _s_334) >>
                                  fun _gen_bind_335 ->
                                     (_k_333 _gen_bind_335) >>
                                     fun _gen_bind_336 ->  _gen_bind_336
                                     _s_334)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (_interp_339
                      ((Assign ((Num 1), (Num 2)))))) >>
                      fun _gen_bind_472 ->  _gen_bind_472 [])

;;

_assert_13
(Pervasives.(=) _test4_471 2)

;;


let _test6_475 = run ((handle { value_clause = (fun _y_354 ->
                                                   value (fun _ ->
                                                   value _y_354));
                               finally_clause = (fun _gen_id_par_353 ->
                                                    value _gen_id_par_353);
                               effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_LookupLoc -> (fun (_x_356 :  loc) (_k_355 :  int -> _ computation) -> value (fun _s_357 ->
                                  (_lookupState_257 _x_356) >>
                                  fun _gen_bind_358 ->
                                     (_gen_bind_358 _s_357) >>
                                     fun _gen_bind_359 ->
                                        (_k_355 _gen_bind_359) >>
                                        fun _gen_bind_360 ->  _gen_bind_360
                                        _s_357)) | Effect_UpdateLoc -> (fun ((
                               _x_363, _y_362) : ( loc*
                                int)) (_k_361 :  loc -> _ computation) -> value (fun _s_364 ->
                                  (_k_361 _x_363) >>
                                  fun _gen_bind_365 ->
                                     ((_updateState_267 _x_363) >>
                                      fun _gen_bind_367 ->
                                         (_gen_bind_367 _y_362) >>
                                         fun _gen_bind_368 ->  _gen_bind_368
                                         _s_364) >>
                                     fun _gen_bind_366 ->  _gen_bind_365
                                     _gen_bind_366)) | Effect_AllocLoc -> (fun (() :  unit) (_k_369 :  loc -> _ computation) -> value (fun _s_370 ->
                                  (_getNewLoc_288 _s_370) >>
                                  fun _gen_bind_371 ->
                                     (_k_369 _gen_bind_371) >>
                                     fun _gen_bind_372 ->  _gen_bind_372
                                     _s_370)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (handle {
                       value_clause = (fun _ ->
                                          handle { value_clause = (fun _gen_id_par_350 ->
                                                                     value _gen_id_par_350);
                                                  finally_clause = (fun _gen_id_par_349 ->
                                                                     value _gen_id_par_349);
                                                  effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_Arith_DivByZero -> (fun (() :  unit) (_k_351 :  int -> _ computation) -> value (Pervasives.(~-)
                                                  1)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (_interp_339
                                       ((Deref (Num 1)))));
                      finally_clause = (fun _gen_id_par_348 ->
                                           value _gen_id_par_348);
                      effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_Arith_DivByZero -> (fun (() :  unit) (_k_352 :  int -> _ computation) -> value (Pervasives.(~-)
                      1)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (_interp_339
                      ((Assign ((Num 1), (Div ((Num 4), (Num 2))))))))) >>
                      fun _gen_bind_476 ->  _gen_bind_476 [])

;;

_assert_13
(Pervasives.(=) _test6_475 2)

;;


let _test7_479 = run ((handle { value_clause = (fun _gen_bind_461 ->
                                                   handle { value_clause = (
                                                           fun _y_463 ->
                                                              value (fun _ ->
                                                              value _y_463));
                                                           finally_clause = (
                                                           fun _gen_id_par_462 ->
                                                              value _gen_id_par_462);
                                                           effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_LookupLoc -> (fun (_x_465 :  loc) (_k_464 :  int -> _ computation) -> value (fun _s_466 ->
                                                              (_lookupState_257
                                                              _x_465) >>
                                                              fun _gen_bind_467 ->
                                                                 (_gen_bind_467
                                                                 _s_466) >>
                                                                 fun _gen_bind_468 ->
                                                                    (_k_464
                                                                    _gen_bind_468)
                                                                    >>
                                                                    fun _gen_bind_469 ->
                                                                     _gen_bind_469
                                                                    _s_466)) | Effect_UpdateLoc -> (fun ((
                                                           _x_472, _y_471) : ( loc*
                                                            int)) (_k_470 :  loc -> _ computation) -> value (fun _s_473 ->
                                                              (_k_470 _x_472)
                                                              >>
                                                              fun _gen_bind_474 ->
                                                                 ((_updateState_267
                                                                  _x_472) >>
                                                                  fun _gen_bind_476 ->

                                                                  (_gen_bind_476
                                                                  _y_471) >>
                                                                  fun _gen_bind_477 ->
                                                                     _gen_bind_477
                                                                  _s_473) >>
                                                                 fun _gen_bind_475 ->
                                                                    _gen_bind_474
                                                                 _gen_bind_475)) | Effect_AllocLoc -> (fun (() :  unit) (_k_478 :  loc -> _ computation) -> value (fun _s_479 ->
                                                              (_getNewLoc_288
                                                              _s_479) >>
                                                              fun _gen_bind_480 ->
                                                                 (_k_478
                                                                 _gen_bind_480)
                                                                 >>
                                                                 fun _gen_bind_481 ->
                                                                    _gen_bind_481
                                                                 _s_479)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (_gen_bind_461
                                                (((::) (("a", 1), [])))));
                               finally_clause = (fun _gen_id_par_460 ->
                                                    value _gen_id_par_460);
                               effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_LookupLoc -> (fun (_x_483 :  loc) (_k_482 :  int -> _ computation) -> value (fun _s_484 ->
                                  (_lookupState_257 _x_483) >>
                                  fun _gen_bind_485 ->
                                     (_gen_bind_485 _s_484) >>
                                     fun _gen_bind_486 ->
                                        (_k_482 _gen_bind_486) >>
                                        fun _gen_bind_487 ->  _gen_bind_487
                                        _s_484)) | Effect_UpdateLoc -> (fun ((
                               _x_490, _y_489) : ( loc*
                                int)) (_k_488 :  loc -> _ computation) -> value (fun _s_491 ->
                                  (_k_488 _x_490) >>
                                  fun _gen_bind_492 ->
                                     ((_updateState_267 _x_490) >>
                                      fun _gen_bind_494 ->
                                         (_gen_bind_494 _y_489) >>
                                         fun _gen_bind_495 ->  _gen_bind_495
                                         _s_491) >>
                                     fun _gen_bind_493 ->  _gen_bind_492
                                     _gen_bind_493)) | Effect_AllocLoc -> (fun (() :  unit) (_k_496 :  loc -> _ computation) -> value (fun _s_497 ->
                                  (_getNewLoc_288 _s_497) >>
                                  fun _gen_bind_498 ->
                                     (_k_496 _gen_bind_498) >>
                                     fun _gen_bind_499 ->  _gen_bind_499
                                     _s_497)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (handle {
                       value_clause = (fun _y_449 ->  value (fun _ ->
                                          value _y_449));
                      finally_clause = (fun _gen_id_par_448 ->
                                           value _gen_id_par_448);
                      effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_InEnv -> (fun ((
                      _env_452, _s_451) : ( env*
                       int)) (_k_450 :  int -> _ computation) -> value (fun _ ->
                         (_k_450 _s_451) >>
                         fun _gen_bind_453 ->  _gen_bind_453 _env_452)) | Effect_ReadEnv -> (fun (() :  unit) (_k_454 :  env -> _ computation) -> value (fun _env_455 ->
                         (_k_454 _env_455) >>
                         fun _gen_bind_456 ->  _gen_bind_456 _env_455)) | Effect_SetEnv -> (fun (_env_458 :  env) (_k_457 :  env -> _ computation) -> value (fun _ ->
                         (_k_457 _env_458) >>
                         fun _gen_bind_459 ->  _gen_bind_459 _env_458)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (_interp_339
                      ((Deref (Var "a")))))) >>
                      fun _gen_bind_480 ->  _gen_bind_480
                      (((::) ((1, 7), []))))

;;

_assert_13 (Pervasives.(=)
_test7_479 7)

;;


let _test8_484 = run ((handle { value_clause = (fun _y_503 ->
                                                   value (fun _ ->
                                                   value _y_503));
                               finally_clause = (fun _gen_id_par_502 ->
                                                    value _gen_id_par_502);
                               effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_InEnv -> (fun ((
                               _env_506, _s_505) : ( env*
                                int)) (_k_504 :  int -> _ computation) -> value (fun _ ->
                                  (_k_504 _s_505) >>
                                  fun _gen_bind_507 ->  _gen_bind_507
                                  _env_506)) | Effect_ReadEnv -> (fun (() :  unit) (_k_508 :  env -> _ computation) -> value (fun _env_509 ->
                                  (_k_508 _env_509) >>
                                  fun _gen_bind_510 ->  _gen_bind_510
                                  _env_509)) | Effect_SetEnv -> (fun (_env_512 :  env) (_k_511 :  env -> _ computation) -> value (fun _ ->
                                  (_k_511 _env_512) >>
                                  fun _gen_bind_513 ->  _gen_bind_513
                                  _env_512)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (_interp_339
                      ((App ((LambdaV ("a", (Var "a"))), (Num 8)))))) >>
                      fun _gen_bind_485 ->  _gen_bind_485 [])

;;

_assert_13
(Pervasives.(=) _test8_484 8)

;;


let _test9_488 = run ((handle { value_clause = (fun _loc_580 ->
                                                   handle { value_clause = (
                                                           fun _y_583 ->
                                                              value (fun _ ->
                                                              value _y_583));
                                                           finally_clause = (
                                                           fun _gen_id_par_582 ->
                                                              value _gen_id_par_582);
                                                           effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_LookupLoc -> (fun (_x_585 :  loc) (_k_584 :  int -> _ computation) -> value (fun _s_586 ->
                                                              (_lookupState_257
                                                              _x_585) >>
                                                              fun _gen_bind_587 ->
                                                                 (_gen_bind_587
                                                                 _s_586) >>
                                                                 fun _gen_bind_588 ->
                                                                    (_k_584
                                                                    _gen_bind_588)
                                                                    >>
                                                                    fun _gen_bind_589 ->
                                                                     _gen_bind_589
                                                                    _s_586)) | Effect_UpdateLoc -> (fun ((
                                                           _x_592, _y_591) : ( loc*
                                                            int)) (_k_590 :  loc -> _ computation) -> value (fun _s_593 ->
                                                              (_k_590 _x_592)
                                                              >>
                                                              fun _gen_bind_594 ->
                                                                 ((_updateState_267
                                                                  _x_592) >>
                                                                  fun _gen_bind_596 ->

                                                                  (_gen_bind_596
                                                                  _y_591) >>
                                                                  fun _gen_bind_597 ->
                                                                     _gen_bind_597
                                                                  _s_593) >>
                                                                 fun _gen_bind_595 ->
                                                                    _gen_bind_594
                                                                 _gen_bind_595)) | Effect_AllocLoc -> (fun (() :  unit) (_k_598 :  loc -> _ computation) -> value (fun _s_599 ->
                                                              (_getNewLoc_288
                                                              _s_599) >>
                                                              fun _gen_bind_600 ->
                                                                 (_k_598
                                                                 _gen_bind_600)
                                                                 >>
                                                                 fun _gen_bind_601 ->
                                                                    _gen_bind_601
                                                                 _s_599)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (
                                                (_interp_339
                                                ((Ref (Num 101)))) >>
                                                fun _loc2_581 ->  _interp_339
                                                ((Deref (Num _loc2_581)))));
                               finally_clause = (fun _gen_id_par_579 ->
                                                    value _gen_id_par_579);
                               effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_LookupLoc -> (fun (_x_603 :  loc) (_k_602 :  int -> _ computation) -> value (fun _s_604 ->
                                  (_lookupState_257 _x_603) >>
                                  fun _gen_bind_605 ->
                                     (_gen_bind_605 _s_604) >>
                                     fun _gen_bind_606 ->
                                        (_k_602 _gen_bind_606) >>
                                        fun _gen_bind_607 ->  _gen_bind_607
                                        _s_604)) | Effect_UpdateLoc -> (fun ((
                               _x_610, _y_609) : ( loc*
                                int)) (_k_608 :  loc -> _ computation) -> value (fun _s_611 ->
                                  (_k_608 _x_610) >>
                                  fun _gen_bind_612 ->
                                     ((_updateState_267 _x_610) >>
                                      fun _gen_bind_614 ->
                                         (_gen_bind_614 _y_609) >>
                                         fun _gen_bind_615 ->  _gen_bind_615
                                         _s_611) >>
                                     fun _gen_bind_613 ->  _gen_bind_612
                                     _gen_bind_613)) | Effect_AllocLoc -> (fun (() :  unit) (_k_616 :  loc -> _ computation) -> value (fun _s_617 ->
                                  (_getNewLoc_288 _s_617) >>
                                  fun _gen_bind_618 ->
                                     (_k_616 _gen_bind_618) >>
                                     fun _gen_bind_619 ->  _gen_bind_619
                                     _s_617)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (_interp_339
                      ((Ref (Num 100))))) >>
                      fun _gen_bind_489 ->  _gen_bind_489 [])

;;

_assert_13
(Pervasives.(=) _test9_488 101)

;;


let _test10_494 = run ((handle { value_clause = (fun _loc_686 ->
                                                    handle { value_clause = (
                                                            fun _y_689 ->
                                                               value (fun _ ->
                                                               value _y_689));
                                                            finally_clause = (
                                                            fun _gen_id_par_688 ->
                                                               value _gen_id_par_688);
                                                            effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_LookupLoc -> (fun (_x_691 :  loc) (_k_690 :  int -> _ computation) -> value (fun _s_692 ->
                                                               (_lookupState_257
                                                               _x_691) >>
                                                               fun _gen_bind_693 ->
                                                                  (_gen_bind_693
                                                                  _s_692) >>
                                                                  fun _gen_bind_694 ->

                                                                  (_k_690
                                                                  _gen_bind_694)
                                                                  >>
                                                                  fun _gen_bind_695 ->
                                                                     _gen_bind_695
                                                                  _s_692)) | Effect_UpdateLoc -> (fun ((
                                                            _x_698, _y_697) : ( loc*
                                                             int)) (_k_696 :  loc -> _ computation) -> value (fun _s_699 ->
                                                               (_k_696
                                                               _x_698) >>
                                                               fun _gen_bind_700 ->
                                                                  ((_updateState_267
                                                                   _x_698) >>
                                                                   fun _gen_bind_702 ->

                                                                   (_gen_bind_702
                                                                   _y_697) >>
                                                                   fun _gen_bind_703 ->
                                                                     _gen_bind_703
                                                                   _s_699) >>
                                                                  fun _gen_bind_701 ->
                                                                     _gen_bind_700
                                                                  _gen_bind_701)) | Effect_AllocLoc -> (fun (() :  unit) (_k_704 :  loc -> _ computation) -> value (fun _s_705 ->
                                                               (_getNewLoc_288
                                                               _s_705) >>
                                                               fun _gen_bind_706 ->
                                                                  (_k_704
                                                                  _gen_bind_706)
                                                                  >>
                                                                  fun _gen_bind_707 ->
                                                                     _gen_bind_707
                                                                  _s_705)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (
                                                 (_interp_339
                                                 ((Ref (Num 101)))) >>
                                                 fun _loc2_687 ->
                                                    _interp_339
                                                 ((Deref (Num _loc_686)))));
                                finally_clause = (fun _gen_id_par_685 ->
                                                     value _gen_id_par_685);
                                effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_LookupLoc -> (fun (_x_709 :  loc) (_k_708 :  int -> _ computation) -> value (fun _s_710 ->
                                   (_lookupState_257 _x_709) >>
                                   fun _gen_bind_711 ->
                                      (_gen_bind_711 _s_710) >>
                                      fun _gen_bind_712 ->
                                         (_k_708 _gen_bind_712) >>
                                         fun _gen_bind_713 ->  _gen_bind_713
                                         _s_710)) | Effect_UpdateLoc -> (fun ((
                                _x_716, _y_715) : ( loc*
                                 int)) (_k_714 :  loc -> _ computation) -> value (fun _s_717 ->
                                   (_k_714 _x_716) >>
                                   fun _gen_bind_718 ->
                                      ((_updateState_267 _x_716) >>
                                       fun _gen_bind_720 ->
                                          (_gen_bind_720 _y_715) >>
                                          fun _gen_bind_721 ->  _gen_bind_721
                                          _s_717) >>
                                      fun _gen_bind_719 ->  _gen_bind_718
                                      _gen_bind_719)) | Effect_AllocLoc -> (fun (() :  unit) (_k_722 :  loc -> _ computation) -> value (fun _s_723 ->
                                   (_getNewLoc_288 _s_723) >>
                                   fun _gen_bind_724 ->
                                      (_k_722 _gen_bind_724) >>
                                      fun _gen_bind_725 ->  _gen_bind_725
                                      _s_723)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (_interp_339
                       ((Ref (Num 100))))) >>
                       fun _gen_bind_495 ->  _gen_bind_495 [])

;;


_assert_13 (Pervasives.(=) _test10_494 100)

;;


let _bigTest_500 = run ((handle { value_clause = (fun _y_729 ->
                                                     value (fun _ ->
                                                     value _y_729));
                                 finally_clause = (fun _gen_id_par_728 ->
                                                      value _gen_id_par_728);
                                 effect_clauses = (fun (type a) (type b) (x : (a, b) effect) ->
             ((match x with | Effect_InEnv -> (fun ((
                                 _env_732, _s_731) : ( env*
                                  int)) (_k_730 :  int -> _ computation) -> value (fun _ ->
                                    (_k_730 _s_731) >>
                                    fun _gen_bind_733 ->  _gen_bind_733
                                    _env_732)) | Effect_ReadEnv -> (fun (() :  unit) (_k_734 :  env -> _ computation) -> value (fun _env_735 ->
                                    (_k_734 _env_735) >>
                                    fun _gen_bind_736 ->  _gen_bind_736
                                    _env_735)) | Effect_SetEnv -> (fun (_env_738 :  env) (_k_737 :  env -> _ computation) -> value (fun _ ->
                                    (_k_737 _env_738) >>
                                    fun _gen_bind_739 ->  _gen_bind_739
                                    _env_738)) | eff' -> fun arg k -> Call (eff', arg, k)) : a -> (b -> _ computation) -> _ computation)) } (_interp_339
                        ((Add ((Add ((Add ((Num 1), (Num 2))),
                                     (Add ((Num 1), (Num 2))))),
                               (Add ((Add ((Num 1), (Num 2))),
                                     (Add ((Num 1), (Num 2)))))))))) >>
                        fun _gen_bind_502 ->
                           (_gen_bind_502 []) >> fun _y_741 ->  value _y_741)
