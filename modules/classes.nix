{ den, lib, ... }:
let
  roleClass =
    { host, user }:
    { class, aspect-chain }:
    den.batteries.forward {
      each = lib.intersectLists (host.roles or [ ]) (user.roles or [ ]);
      fromClass = lib.id;
      intoClass = _: host.class;
      intoPath = _: [ ];
      fromAspect = _: lib.head aspect-chain;
    };
in
{
  den.schema.user.includes = [ roleClass ];
}
