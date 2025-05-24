module voting_system::voting {

    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::vector;
    use sui::balance;
    use sui::address;
    use sui::event;

    struct Voter has key {
        voted: bool,
    }

    struct Proposal has key {
        id: u64,
        title: vector<u8>,
        votes: u64,
    }

    struct VotingSystem has key {
        id: UID,
        proposals: vector<Proposal>,
        voters: table::Table<address::Address, Voter>,
    }

    public fun init(ctx: &mut TxContext): VotingSystem {
        let uid = object::new(ctx);
        VotingSystem {
            id: uid,
            proposals: vector::empty<Proposal>(),
            voters: table::new<address::Address, Voter>(),
        }
    }

    public fun create_proposal(system: &mut VotingSystem, title: vector<u8>) {
        let proposal = Proposal {
            id: vector::length(&system.proposals) as u64,
            title,
            votes: 0,
        };
        vector::push_back(&mut system.proposals, proposal);
    }

    public fun vote(system: &mut VotingSystem, proposal_id: u64, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);

        if (table::contains(&system.voters, &sender)) {
            assert!(!table::borrow(&system.voters, &sender).voted, 0);
        }

        let voter = Voter { voted: true };
        table::insert(&mut system.voters, sender, voter);

        let mut proposal = vector::borrow_mut(&mut system.proposals, proposal_id);
        proposal.votes = proposal.votes + 1;
    }

    public fun get_results(system: &VotingSystem): vector<Proposal> {
        system.proposals
    }
}
