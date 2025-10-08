module marcelo_registry::project_registry {

    use sui::tx_context::{TxContext, sender};
    use sui::clock;
    use sui::object::{Self, UID};
    use sui::event;
    use std::string::{String, utf8};
    use std::vector;

    struct ProjectRegistered has copy, drop, store {
        id: u64,
        owner: address,
        title: String,
        link: String,
        created_at: u64,
    }

    struct ProjectUpdated has copy, drop, store {
        id: u64,
        owner: address,
        new_title: String,
        new_link: String,
        updated_at: u64,
    }

    struct Project has key, store {
        id: u64,
        owner: address,
        title: String,
        link: String,
        created_at: u64,
        updated_at: u64,
        active: bool,
    }

    struct GlobalRegistry has key {
        id: UID,
        counter: u64,
        projects: vector<Project>,
    }

    public entry fun init_registry(ctx: &mut TxContext) {
        let registry = GlobalRegistry {
            id: object::new(ctx),
            counter: 0,
            projects: vector::empty<Project>(),
        };
        move_to(&sender(ctx), registry);
    }

    public entry fun register_project(
        title: String,
        link: String,
        clock: &clock::Clock,
        ctx: &mut TxContext
    ) {
        let sender_addr = sender(ctx);
        let registry = borrow_global_mut<GlobalRegistry>(sender_addr);

        let id = registry.counter;
        registry.counter = id + 1;

        let now = clock::now_ms(clock);

        let project = Project {
            id,
            owner: sender_addr,
            title: title.clone(),
            link: link.clone(),
            created_at: now,
            updated_at: now,
            active: true,
        };

        vector::push_back(&mut registry.projects, project);

        event::emit(ProjectRegistered {
            id,
            owner: sender_addr,
            title,
            link,
            created_at: now,
        });
    }

    public entry fun update_project(
        project_id: u64,
        new_title: String,
        new_link: String,
        clock: &clock::Clock,
        ctx: &mut TxContext
    ) {
        let sender_addr = sender(ctx);
        let registry = borrow_global_mut<GlobalRegistry>(sender_addr);
        let mut i = 0;
        let len = vector::length(&registry.projects);

        while (i < len) {
            let project = &mut vector::borrow_mut(&mut registry.projects, i);
            if (project.id == project_id && project.active) {
                assert!(project.owner == sender_addr, 1);
                project.title = new_title.clone();
                project.link = new_link.clone();
                project.updated_at = clock::now_ms(clock);

                event::emit(ProjectUpdated {
                    id: project_id,
                    owner: sender_addr,
                    new_title,
                    new_link,
                    updated_at: project.updated_at,
                });
                return;
            };
            i = i + 1;
        };
        abort 2;
    }

    public fun list_projects(): vector<Project> {
        let all = &borrow_global<GlobalRegistry>(@0xYourAddress).projects;
        vector::copy(all)
    }
}
