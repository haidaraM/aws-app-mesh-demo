# End-To-End Encryption AWS AppMesh

A Terraform project creating an ECS service with AppMesh and End-To-End Encryption. This repository is the source code
associated with my series of posts regarding App Mesh:

- [Part 1](./part-1): A single ECS service inside a Mesh and behind a load balancer connected to it via TLS (end-to-end
  encryption)
- Part 2: Two services in the mesh communicating with each other with end-to-end encryption (coming soon) 

You can find the full article on my blog here (in
French): https://blog.haidara.io/post/aws-app-mesh-partie-1-terminaison-tls/

## Repository structure

```
.
├── app/ # The source code of the application
├── modules/
│   ├── common/ # Common resources between the different stacks
│   └── ecs-meshed-service/ # A meshed ECS service
├── part-1/
└── tests/
```

