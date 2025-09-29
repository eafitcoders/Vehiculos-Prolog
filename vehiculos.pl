vehiculo(nissan, z37, sport, 38000, 2021).
vehiculo(ford, mustang, sport, 45000, 2023).
vehiculo(ford, edge, suv, 10000, 2017).
vehiculo(toyota, corolla, sedan, 22000, 2022).
vehiculo(toyota, yaris, suv, 45000, 2024).
vehiculo(bmw, x5, suv, 60000, 2021).
vehiculo(bmw, m4, sport, 100000, 2022).
vehiculo(chevrolet, camaro, sport, 50000, 2024).
vehiculo(honda, civic, sedan, 23000, 2023).
vehiculo(honda, crv, suv, 32000, 2022).
vehiculo(mazda, cx30, suv, 30000, 2022).

vehicle(Marca, Ref, Tipo, Precio, Anio) :- vehiculo(Marca, Ref, Tipo, Precio, Anio).

encontrar_presupuesto(Referencia, PresupuestoMax) :-
    vehiculo(_, Referencia, _, Precio, _),
    Precio =< PresupuestoMax.

meet_budget(Ref, Max) :- encontrar_presupuesto(Ref, Max).

encontrar_tipo_de_presupuesto(Referencia, Tipo, PresupuestoMax) :-
    vehiculo(_, Referencia, Tipo, Precio, _),
    Precio =< PresupuestoMax.

vehiculos_por_marca(Marca, ListaReferencias) :-
    findall(Referencia, vehiculo(Marca, Referencia, _, _, _), ListaReferencias).

vehiculos_en_lista(Marca, Tipo, ListaReferencias) :-
    bagof(Referencia, vehiculo(Marca, Referencia, Tipo, _, _), ListaReferencias).

precio_total([], 0).
precio_total([(_, Precio)|T], Total) :-
    precio_total(T, Sub),
    Total is Precio + Sub.

candidatos(Marca, Tipo, Presupuesto, OrdenadosPorPrecio) :-
    findall((Precio, Ref),
            ( vehiculo(Marca, Ref, Tipo, Precio, _),
              Precio =< Presupuesto),
            Pares),
    msort(Pares, OrdenadosPorPrecio).

tomar_hasta_limite([], _, [], 0).
tomar_hasta_limite([(Precio,Ref)|T], Limite, [(Ref,Precio)|Sel], Total) :-
    Precio =< Limite,
    LimiteRest is Limite - Precio,
    tomar_hasta_limite(T, LimiteRest, Sel, Sub),
    Total is Precio + Sub.
tomar_hasta_limite([(Precio,_)|_], Limite, [], 0) :-
    Precio > Limite.
tomar_hasta_limite(_, _, [], 0).

limite_global(1000000).

generate_report(Marca, Tipo, Presupuesto, (ListaReferencias, ValorTotal)) :-
    limite_global(Limite),
    candidatos(Marca, Tipo, Presupuesto, Ordenados),
    tomar_hasta_limite(Ordenados, Limite, Seleccion, ValorTotal),
    findall(Ref, member((Ref,_), Seleccion), ListaReferencias).

generar_reporte(Marca, Tipo, Presupuesto, (ListaReferencias, ValorTotal)) :-
    generate_report(Marca, Tipo, Presupuesto, (ListaReferencias, ValorTotal)).

ford_por_tipo_y_anio(L) :-
    bagof((Tipo, Anio, Ref), P^vehiculo(ford, Ref, Tipo, P, Anio), L).

generate_report_sedan_500k((Lista, Total)) :-
    candidatos(_, sedan, 500000, Ordenados),
    tomar_hasta_limite(Ordenados, 500000, Sel, Total),
    findall(Ref, member((Ref,_), Sel), Lista).