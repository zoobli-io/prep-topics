using System;
using DataStructures.Graph;

namespace Algorithms.Graph
{
    public interface IGraphSearch<T>
    {
        void VisitAll(IDirectedWeightedGraph<T> graph, Vertex<T> startVertex, Action<Vertex<T>>? action = null);
    }
}
