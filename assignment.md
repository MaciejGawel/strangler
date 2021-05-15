# Assignment

As a part of the assignment, you are expected to add [Zipkin][1] to the project.

Zipkin is an Open Source project that provides mechanisms for sending,
receiving, storing, and visualizing traces. This allows operators to correlate
activity between servers and get a much clearer picture of precisely what is
happening in application services.

## Implementation instructions

- Deploy Zipkin Server using existing Docker image
  (e.g., [openzipkin/zipkin][2])
- Add Zipkin Client to existing microservices
- Gather spans from all microservices (including Gateway)

---

**NOTE:** You don't have to register Zipkin Server in Eureka. Instead, you can
use a hostname identical to the Zipkin container name (see [networking in
Compose][3] and [Issue #1][4]).

---

## Outcomes

As a result of this exercise, prepare a report containing detailed information
about:

- introduced changes
- system configuration
- performed tests

Prepare a *pdf* file that contains all required details and dashboard
screenshots.

[1]: https://zipkin.io/
[2]: https://hub.docker.com/r/openzipkin/zipkin
[3]: https://docs.docker.com/compose/networking/
[4]: https://github.com/MaciejGawel/strangler/issues/1
