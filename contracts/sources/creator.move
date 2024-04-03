module creator:: suiroad{
  use std::option::{Self, Option};

    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct Product has key, store {
         id: UID,
        title: u8,
    }
     public entry fun create_product(id: u8, ctx: &mut TxContext) {
        let Product = Product {
            id: object::new(ctx),
            titlw,
        };
        transfer::transfer(Product, tx_context::sender(ctx))
    }  
}