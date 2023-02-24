client.test("Request came from envoy", function () {
    client.assert(response.headers.valueOf("server") === "envoy", "The 'server' header is not envoy");

});

client.test("Request should have the upstream service time from envoy", function () {
    const upstreamHeader = "x-envoy-upstream-service-time"
    client.assert(response.headers.valueOf(upstreamHeader) !== undefined, `The header ${upstreamHeader} is missing`)
});
