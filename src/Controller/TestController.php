<?php
// src/Controller/TestController.php

namespace App\Controller;

use App\Entity\StreamingService;
use App\Repository\StreamingServiceRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class TestController extends AbstractController
{
    #[Route('/test-streaming')]
    public function streaming(StreamingServiceRepository $repo): Response
    {
        return $this->render('test/streaming.html.twig', [
            'services' => $repo->findAllOrdered(),
        ]);
    }
    #[Route('/delete-service/{id}', name: 'app_delete_service')]
    public function delete(int $id, EntityManagerInterface $em): Response
    {
        $service = $em->getRepository(StreamingService::class)->find($id);

        if ($service) {
            $em->remove($service);
            $em->flush();
        }

        return $this->redirectToRoute('app_test_streaming');
    }
    #[Route('/add-service', name: 'app_add_service')]
    public function add(Request $request, EntityManagerInterface $em): Response
    {
        if ($request->isMethod('POST')) {
            $name = $request->request->get('name');
            $website = $request->request->get('website');

            if (!empty($name) && !empty($website)) {
                $service = new StreamingService();
                $service->setName($name);
                $service->setWebsite($website);

                $em->persist($service);
                $em->flush();

                return $this->redirectToRoute('app_test_streaming');
            }
        }

        return $this->render('test/add_simple.html.twig');
    }
}
