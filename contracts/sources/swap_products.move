module suiroad::swap {
    use sui::dynamic_object_field::{Self as dof};
    use sui::transfer;
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};

    // === Struct Definitions ===

    /// Marker struct for dynamic object fields
    public struct LockedObjectKey has copy, store, drop {}

    /// Represents a locked object with an associated key
    public struct Locked<phantom T: key + store> has key, store {
        id: UID,
        key: ID,
    }

    /// Represents a key to unlock a locked object
    public struct Key has key, store { id: UID }

    /// Represents an escrow arrangement for exchanging objects
    public struct Escrow<T: key + store> has key {
        id: UID,
        sender: address,
        recipient: address,
        exchange_key: ID,
        escrowed_key: ID,
        escrowed: T,
    }

    // === Error Codes ===

    /// Error code for mismatched sender and recipient
    const EMismatchedSenderRecipient: u64 = 0;
    /// Error code for mismatched exchange keys
    const EMismatchedExchangeObject: u64 = 1;
    /// Error code for lock key mismatch
    const ELockKeyMismatch: u64 = 2;

    // === Public Functions ===

    /// Creates an escrow arrangement for a locked object
    public fun create<T: key + store>(
        key: Key,
        mut locked: Locked<T>,
        exchange_key: ID,
        recipient: address,
        custodian: address,
        ctx: &mut TxContext,
    ) {
        let escrowed = unlock_internal(&mut locked, key);
        let escrow = Escrow {
            id: object::new(ctx),
            sender: ctx.sender(),
            recipient,
            exchange_key,
            escrowed_key: object::id(&key),
            escrowed,
        };

        transfer::transfer(escrow, custodian);
    }

    /// Swaps two escrowed objects
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

        assert!(sender1 == recipient2, EMismatchedSenderRecipient);
        assert!(sender2 == recipient1, EMismatchedSenderRecipient);
        assert!(escrowed_key1 == exchange_key2, EMismatchedExchangeObject);
        assert!(escrowed_key2 == exchange_key1, EMismatchedExchangeObject);

        transfer::public_transfer(escrowed1, recipient1);
        transfer::public_transfer(escrowed2, recipient2);
    }

    /// Returns an escrowed object to its original owner
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

    /// Unlocks a locked object using the provided key
    public fun unlock<T: key + store>(mut locked: Locked<T>, key: Key): T {
        assert!(locked.key == object::id(&key), ELockKeyMismatch);
        let obj = unlock_internal(&mut locked, key);
        obj
    }

    // === Internal Helper Functions ===

    /// Internal function to unlock a locked object
    fun unlock_internal<T: key + store>(mut locked: Locked<T>, key: Key): T {
        assert!(locked.key == object::id(&key), ELockKeyMismatch);
        let Key { id } = key;
        id.delete();

        let obj = dof::remove<LockedObjectKey, T>(&mut locked.id, LockedObjectKey {});

        let Locked { id, key: _ } = locked;
        id.delete();
        obj
    }
}
