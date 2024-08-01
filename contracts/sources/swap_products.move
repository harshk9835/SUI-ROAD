module suiroad::swap {
    use sui::dynamic_object_field::{Self as dof};

    public struct LockedObjectKey has copy, store, drop {}

    public struct Locked<phantom T: key + store> has key, store {
        id: UID,
        key: ID,
    }

    /// Key to open a locked object (consuming the `Key`)
    public struct Key has key, store { id: UID }

    public struct Escrow<T: key + store> has key {
        id: UID,
        sender: address,
        recipient: address,
        exchange_key: ID,
        escrowed_key: ID,
        escrowed: T,
    }

    // === Error codes ===

    /// The `sender` and `recipient` of the two escrowed objects do not match
    const EMismatchedSenderRecipient: u64 = 0;

    /// The `exchange_key` fields of the two escrowed objects do not match
    const EMismatchedExchangeObject: u64 = 1;

    /// The key does not match this lock.
    const ELockKeyMismatch: u64 = 2;

    // === Public Functions ===
    public fun create<T: key + store>(
        key: Key,
        locked: Locked<T>,
        exchange_key: ID,
        recipient: address,
        custodian: address,
        ctx: &mut TxContext,
    ) {
        let escrow = Escrow {
            id: object::new(ctx),
            sender: ctx.sender(),
            recipient,
            exchange_key,
            escrowed_key: object::id(&key),
            escrowed: locked.unlock(key),
        };

        transfer::transfer(escrow, custodian);
    }

    public fun swap<T: key + store, U: key + store>(
        obj1: Escrow<T>,
        obj2: Escrow<U>,
    ) {
        let Escrow {
            id: id1,
            sender: sender1,
            recipient: recipient1,
            exchange_key: exchange_key1,
            escrowed_key: escrowed_key1,
            escrowed: escrowed1,
        } = obj1;

        let Escrow {
            id: id2,
            sender: sender2,
            recipient: recipient2,
            exchange_key: exchange_key2,
            escrowed_key: escrowed_key2,
            escrowed: escrowed2,
        } = obj2;
        id1.delete();
        id2.delete();

        // Make sure the sender and recipient match each other
        assert!(sender1 == recipient2, EMismatchedSenderRecipient);
        assert!(sender2 == recipient1, EMismatchedSenderRecipient);

        // Make sure the objects match each other and haven't been modified
        // (they remain locked).
        assert!(escrowed_key1 == exchange_key2, EMismatchedExchangeObject);
        assert!(escrowed_key2 == exchange_key1, EMismatchedExchangeObject);

        // Do the actual swap
        transfer::public_transfer(escrowed1, recipient1);
        transfer::public_transfer(escrowed2, recipient2);
    }

    /// The custodian can always return an escrowed object to its original
    /// owner.
    public fun return_to_sender<T: key + store>(obj: Escrow<T>) {
        let Escrow {
            id,
            sender,
            recipient: _,
            exchange_key: _,
            escrowed_key: _,
            escrowed,
        } = obj;
        id.delete();
        transfer::public_transfer(escrowed, sender);
    }

    public fun unlock<T: key + store>(mut locked: Locked<T>, key: Key): T {
        assert!(locked.key == object::id(&key), ELockKeyMismatch);
        let Key { id } = key;
        id.delete();

        let obj = dof::remove<LockedObjectKey, T>(&mut locked.id, LockedObjectKey {});

        let Locked { id, key: _ } = locked;
        id.delete();
        obj
    }
}
