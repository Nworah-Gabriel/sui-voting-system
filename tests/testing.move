module voting_system::voting_test {
    use sui::tx_context::TxContext;
    use voting_system::voting::{init, create_proposal, vote, get_results};
    use sui::vector;

    #[test]
    public fun test_voting(ctx: &mut TxContext) {
        let mut system = init(ctx);
        create_proposal(&mut system, b"President");

        vote(&mut system, 0, ctx);
        let results = get_results(&system);

        // Ensure there's one proposal
        assert!(vector::length(&results) == 1, 0);
        // Check votes
        assert!(vector::borrow(&results, 0).votes == 1, 1);
    }
}
