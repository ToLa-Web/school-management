using System;
using System.Collections.Generic;
using System.Linq;
using Consul;
using YarpConfig = Yarp.ReverseProxy.Configuration;

namespace ApiGateway
{
    public static class DiscoveryConfigFactory
    {
        // Returns a tuple with routes list and clusters list for YARP
        public static (IReadOnlyList<YarpConfig.RouteConfig> Routes, IReadOnlyList<YarpConfig.ClusterConfig> Clusters) BuildFromConsul(string consulHost, int consulPort)
        {
            var clusters = new List<YarpConfig.ClusterConfig>();
            var routes = new List<YarpConfig.RouteConfig>();

            using var consul = new ConsulClient(cfg => cfg.Address = new Uri($"http://{consulHost}:{consulPort}"));

            var services = new[] { "auth-service", "school-service" };

            foreach (var svc in services)
            {
                var destinations = new Dictionary<string, YarpConfig.DestinationConfig>(StringComparer.OrdinalIgnoreCase);

                var response = consul.Health.Service(svc, tag: string.Empty, passingOnly: true).GetAwaiter().GetResult();
                var entries = response.Response ?? Array.Empty<ServiceEntry>();

                for (int i = 0; i < entries.Length; i++)
                {
                    var entry = entries[i];
                    var service = entry.Service;
                    var address = string.IsNullOrEmpty(service.Address)
                        ? $"http://{entry.Node.Address}:{service.Port}"
                        : $"http://{service.Address}:{service.Port}";

                    destinations[$"{svc}-{i}"] = new YarpConfig.DestinationConfig { Address = address };
                }

                if (destinations.Count == 0)
                {
                    destinations[$"{svc}-default"] = new YarpConfig.DestinationConfig { Address = $"http://{svc}:8080/" };
                }

                var cluster = new YarpConfig.ClusterConfig
                {
                    ClusterId = $"{svc}-cluster",
                    Destinations = destinations
                };

                clusters.Add(cluster);

                // create route to match existing path patterns
                var routeId = svc == "auth-service" ? "auth-route" : "school-route";
                var path = svc == "auth-service" ? "/api/auth/{**catch-all}" : "/api/school/{**catch-all}";

                routes.Add(new YarpConfig.RouteConfig
                {
                    RouteId = routeId,
                    ClusterId = cluster.ClusterId,
                    Match = new YarpConfig.RouteMatch { Path = path }
                });
            }

            return (routes, clusters);
        }
    }
}
