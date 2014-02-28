open List

let (|>) = fun v f -> f v

let rec my_partition (eq : 'a -> 'a -> bool) (items : 'a list) : 'a list list  =
    match items with
        [] -> []
        | (l :: _) -> 
            let (m, u) = partition (eq l) items in
            [m] @ my_partition eq u

type b = B of int
type a = A of int * b list

type ai = Ai of int
type bi = Bi of int * ai list

let a_list = [A( 1, [B 1; B 2; B 3] );
              A( 2, [B 2; B 3; B 4] );
              A( 3, [B 3; B 4; B 5] );]

let bi_list = a_list 
    |> map (function A( i, bl ) -> map (fun b -> (Ai i, b)) bl)
    |> flatten
    |> my_partition (function (_, B i1) -> function (_, B i2) -> i1 = i2)
    |> map (fun ls ->
                match ls with
                    ((ai, B i) :: _) -> Bi( i, map (function (ai, _) -> ai) ls))

